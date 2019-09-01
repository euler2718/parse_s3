defmodule ParseS3 do
@filePath "lib/whatever.txt"
@bucket "com.cfins.epw.json.prod"
@formID 534
  @moduledoc """
  Documentation for ParseS3.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ParseS3.hello()
      :world

  """
  def hello do
    :world
  end

  def normalCounting do
    a = File.stream!(@filePath)
    |> Enum.flat_map(&String.split(&1, " "))
    |> Enum.reduce(%{}, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)
    IO.inspect(a)
    Enum.to_list(a)
  end

  def streamCounting do
    File.stream!(@filePath)
    |> Stream.flat_map(&String.split(&1, " "))
    |> Enum.reduce(%{}, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)
    |> Enum.to_list()
  end


  def flowCounting do
    File.stream!(@filePath)
    |> Flow.from_enumerable()
    |> Flow.flat_map(&String.split(&1, " "))
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)
    |> Enum.to_list()
  end

  def listS3Keys() do
    ExAws.S3.list_objects(@bucket)
    |> ExAws.stream!
    |> Enum.map(fn x -> x.key end)
  end

  def fileTest() do
    listS3Keys()
    |> Enum.at(1)
  end

  def downloadAllFiles() do
    for file <- listS3Keys() do
      downloadSingleFile(file)
      |> ExAws.request!
    end
  end

  def downloadSingleFile(fileName) do
    with splitter <- String.split(fileName, "/"),
         filename <- splitter |> Enum.at(1)
    do
      ExAws.S3.download_file(@bucket, fileName, "lib/policies/#{filename}")
    end
  end

  def searchFile() do
    f = File.stream!("DRAFT_POLICY_989098.json", read_ahead: 100_000)
    Regex.match?(~r/formID\":\s*#{@formID}/, f)
  end
  
  defp streams() do
    for file <- File.ls!("lib/policies") |> Enum.filter( fn x -> Regex.match?(~r/^POLICY/, x) end) do
      # IO.puts(file)
      File.stream!("lib/policies/#{file}", read_ahead: 100_000)
    end
  end

  def createTuple(json) do
    # IO.inspect(json)
    productNumber = Regex.run(~r/productNumber\":\s*(\d+)/, json) |> List.last
    boolString = Regex.match?(~r/formID\":\s*#{@formID}/, json) |> to_string
    {String.to_atom(boolString), productNumber}
  end

  def mainFlow() do
    streams()
    |> Flow.from_enumerables()
    |> Flow.map(&createTuple(&1))
    |> Flow.partition(key: {:elem, 0})
    |> Flow.reduce(fn -> %{} end, fn x, acc ->
      Map.update(acc, elem(x,0), [elem(x,1)], fn y -> y ++ [elem(x,1)] end)
    end)
    # |> Enum.to_list()
    |> Enum.into(%{})
  end

end
