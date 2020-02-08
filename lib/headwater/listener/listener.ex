defmodule Headwater.Listener do
  @moduledoc """
  Reading events from an event aggregate.
  """

  defmacro __using__(
             from_event_ref: from_event_ref,
             event_store: event_store,
             bus_id: bus_id,
             handlers: handlers
           ) do
    quote do
      defmodule Producer do
        use Headwater.Listener.Provider,
          from_event_ref: unquote(from_event_ref),
          event_store: unquote(event_store),
          bus_id: unquote(bus_id)
      end

      defmodule Consumer do
        use Headwater.Listener.Consumer,
          provider: Producer,
          retry_limit: 5,
          handlers: unquote(handlers)
      end

      def children do
        [Producer, Consumer]
      end
    end
  end

  def web_safe_md5(content) when is_binary(content) do
    :crypto.hash(:md5, content) |> Base.encode16()
  end
end
