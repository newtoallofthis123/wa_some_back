defmodule WaSomeBack.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: WaSomeBack, options: [port: 4000, ip: {0, 0, 0, 0}]}
    ]

    opts = [strategy: :one_for_one, name: WaSomeBack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
