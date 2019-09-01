# ParseS3

**Description**



## Usage

```elixir
C:\Repos\parse_s3>SET AWS_ACCESS_KEY_ID=<<aws access key id>>

C:\Repos\parse_s3>SET AWS_SECRET_ACCESS_KEY=<<aws secret access key>>

# if you do not use a session token, you may comment out the line in the config.exs file:

    config :ex_aws,
        access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
        secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
        # security_token: [{:system, "AWS_SESSION_TOKEN"}, :instance_role]

# otherwise...
C:\Repos\parse_s3>SET AWS_SESSION_TOKEN=<<aws session token>>

C:\Repos\parse_s3>iex -S mix
Interactive Elixir (1.8.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ParseS3.downloadAllFiles
[:done, :done, :done, :done, :done, :done, :done, :done, :done, :done, :done,
 :done, :done, :done, :done, :done, :done, :done, :done, :done, :done, :done,
 :done, :done, :done, :done, :done, :done, :done, :done, :done, :done, :done,
 :done, :done, :done, :done, :done, :done, :done, :done, :done, :done, :done,
 :done, :done, :done, :done, :done, :done, ...]
iex(2)> ParseS3.mainFlow
%{
  false: ["3936750", "3913865", "6811344", "6864055", "6868939", "6869072",
   "3923297", "3935050", "6824687", "6865825", "6868972", "3918198", "3934978",
   "3914850", "3914556", "6858177", "3926236", "6824549", "6864517", "3936653",
   "3936766", "6868964", "3936895", "6858310", "6869158", "6862196", "6825101",
   "6824935", "6868783", "6868861", "3931903", "3936884", "6824917", "6866789",
   "6825124", "6811248", "6825113", "6825320", "6868919", "6825287", "6869037",
   "3937258", "6824842", "6825958", "6824599", "6850935", "6856822", "6825509",
   "6857486", ...],
  true: ["6861275", "6914514", "6857634", "6915099", "6876389", "6864657",
   "6922209", "6947640", "6957847", "6984244"]
}
``