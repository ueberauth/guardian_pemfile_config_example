  # Example of a Guardian configuration using a private and public pem file

*This is just an example of how to get up and running and should not be used in production*

### Highlights
pem files are put in the priv folder and fetched with the secret handler which is configured in the config file.

```elixir
config :pem_guardian, PemGuardian.Guardian,
  issuer: "pem_guardian",
  allowed_algos: ["RS512"],
  secret_fetcher: PemGuardian.SecretFetcher
```

```elixir
defmodule PemGuardian.SecretFetcher do
  @behaviour Guardian.Token.Jwt.SecretFetcher

  @impl true
  def fetch_signing_secret(_module, _opts) do
    "rsa-2048.pem"
    |> fetch()
  end

  @impl true
  def fetch_verifying_secret(_module, _headers, _opts) do
    "rsa-2048.pub"
    |> fetch()
  end

  defp fetch(relative_path) do
    secret =
      relative_path
      |> fetch_key()

    case secret do
      :error -> {:error, :secret_not_found}
      _ -> {:ok, secret}
    end
  end

  defp fetch_key(relative_path) do
    try do
      :code.priv_dir(:mock_idp)
      |> Path.join(relative_path)
      |> JOSE.JWK.from_pem_file()
    rescue
      _ -> :error
    end
  end
end
```
  
Example can be verified with the following commands
```elixir 
{:ok,token,_} = PemGuardian.Guardian.encode_and_sign(%{id: "1"})
PemGuardian.Guardian.decode_and_verify(token) 
```
