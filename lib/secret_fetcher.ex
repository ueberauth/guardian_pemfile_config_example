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
      :code.priv_dir(:pem_guardian)
      |> Path.join(relative_path)
      |> JOSE.JWK.from_pem_file()
    rescue
      _ -> :error
    end
  end
end
