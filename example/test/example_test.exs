defmodule ExampleTest do
  use ExUnit.Case
  use Headwater.TestHelper, event_store_repo: Example.Repo

  test "increments a counter and returns the state in an :ok tuple" do
    assert {:ok, %Example.Counter{total: 5}} ==
             Example.inc(%Example.Increment{counter_id: "abc", increment_by: 5})
  end

  test "idempotent requests return same state" do
    idempotency = "idempo-4535"
    expected_state = %Example.Counter{total: 5}

    assert {:ok, expected_state} ==
             Example.inc(%Example.Increment{counter_id: "idempo-counter", increment_by: 5},
               idempotency_key: idempotency
             )

    assert {:ok, expected_state} ==
             Example.inc(%Example.Increment{counter_id: "idempo-counter", increment_by: 5},
               idempotency_key: idempotency
             )

    assert {:ok, expected_state} ==
             Example.inc(%Example.Increment{counter_id: "idempo-counter", increment_by: 5},
               idempotency_key: idempotency
             )
  end

  test "when counter is empty" do
    assert {:warn, :empty_aggregate} ==
             Example.read_counter("a-nothing-counter")
  end
end
