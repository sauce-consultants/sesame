# Sesame

Basic resource / URL signing for Plug-based Elixir apps.

## Installation

The package can be installed by adding `sesame` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:sesame, "~> 0.1.0"}]
end
```

## Getting Started

Once installed, you'll need to add a couple of core components to your app to get Sesame to work:

  * Serializer - this is responsible for serializing your "Signer" (a User that has the necessary permissions to grant access) to the resulting JWT.
  * Policy - this will be responsible for determining which Users are able to grant access to certain resources.

### Serializer

This sample serializer will take a User struct and store its ID in the resulting JWT (for use / storage client-side). During verification the ID can be taken from the token and the User will be retrieved from the database.

```elixir
defmodule MyApp.SesameSerializer do
  @behaviour Sesame.Serializer

  alias MyApp.{Repo, User}

  def for_token(%{error: :unknown}), do: {:error, "Unknown resource type"}
  def for_token(%User{} = user) do 
    {:ok, "User:#{user.id}"}
  end

  def from_token("User:" <> id) do 
    Repo.get!(User, id)
  end
end
```

### Policy

This sample policy checks the resource to be accessed against the person signing it. If the User has a role of "admin", the resource can be signed/accessed, otherwise an error is thrown.

```elixir
defmodule MyApp.SesamePolicy do
  @behaviour Sesame.Policy

  alias MyApp.{Repo, User}
  
  def is_permitted?("http://myapp.com/export", "User:" <> id) do 
    case Repo.get!(User, id) do
      %User{role: "admin"} -> :ok
      _ -> :error
    end
  end
  def is_permitted?(_, _), do: :error
end
```

### Config

A new config block will need to be added in order to get these parts working:

```elixir
config :sesame, Sesame,
  secret_key: "correct-horse-battery-staple",
  serializer: MyApp.SesameSerializer,
  policy: MyApp.SesamePolicy
```

## Working with Phoenix / Guardian

TODO