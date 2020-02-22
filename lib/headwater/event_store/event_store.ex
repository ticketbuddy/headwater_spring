defmodule Headwater.EventStore do
  @moduledoc """
  Behaviour for storage & reading of events
  """

  @type uuid :: String.t()
  @type aggregate_id :: String.t()
  @type event_id :: uuid
  @type recorded_event :: Headwater.EventStore.RecordedEvent.t()
  @type persist_event :: Headwater.EventStore.PersistEvent.t()
  @type listener_id :: String.t()
  @type idempotency_key :: String.t()
  @type event_number :: non_neg_integer()

  @callback commit([persist_event], idempotency_key: idempotency_key) :: {:ok, [recorded_event]}
  @callback load_events(aggregate_id) :: {:ok, [recorded_event]}
  @callback event_handled(listener_id: listener_id, event_number: event_number) :: :ok
  @callback get_event(event_id) :: {:ok, recorded_event}
  @callback has_wish_previously_succeeded?(idempotency_key) :: true | false
end
