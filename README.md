# Example of a guardian configuration using a private and public pem file

*This is just an example of how to get up and running and should not be used in production*

### Highlights
Pem files are put in the priv folder and fetched with the secret handler which is configured in the config file.

```elixir
config :pem_guardian, PemGuardian.Guardian,
  issuer: "pem_guardian",
  allowed_algos: ["RS512"],
  secret_fetcher: PemGuardian.SecretFetcher
```

``` elixir 
def fetch_signing_secret(_module, _opts) do
    secret =
      "rsa-2048.pem"
      |> fetch()

    {:ok, secret}
  end

  def fetch_verifying_secret(_module, _headers, _opts) do
    secret =
      "rsa-2048.pub"
      |> fetch()

    {:ok, secret}
  end

  defp fetch(relative_path) do
    :code.priv_dir(:debug_guardian)
    |> Path.join(relative_path)
    |> JOSE.JWK.from_pem_file()
  end
  ```
  
  Example can be verified with the following commands
 ``` elixir 
 {:ok,token,_} = PemGuardian.Guardian.encode_and_sign(%{id: "1"})
 PemGuardian.Guardian.decode_and_verify(token) 
 ```




