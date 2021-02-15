defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    operators = %{*: 2, +: 1, -: 1, /: 2}
    op_stack = []
    results = []

    list = expr |> String.split(~r/\s+/)
    results = fill_stack(list, operators, op_stack, results)

    eval_stack = []
    eval = evaluate(results, eval_stack)
    eval |> hd
  end

  def fill_stack(list, operators, op_stack, results) do
    x = List.first(list)

    cond do
      x == nil ->
        results ++ op_stack

      Float.parse(x) != :error ->
        fill_stack(
          list |> tl,
          operators,
          op_stack,
          results ++ [parse_float(x)]
        )

      true ->
        cond do
          List.first(op_stack) == nil ->
            fill_stack(
              list |> tl,
              operators,
              [x | op_stack],
              results
            )

          operators[String.to_atom(x)] > operators[List.first(op_stack) |> String.to_atom()] ->
            fill_stack(
              list |> tl,
              operators,
              [x | op_stack],
              results
            )

          operators[String.to_atom(x)] == operators[List.first(op_stack) |> String.to_atom()] ->
            fill_stack(
              list |> tl,
              operators,
              [x | op_stack |> tl],
              results ++ [op_stack |> hd]
            )

          operators[String.to_atom(x)] < operators[List.first(op_stack) |> String.to_atom()] ->
            fill_stack(
              list,
              operators,
              op_stack |> tl,
              results ++ [op_stack |> hd]
            )
        end
    end
  end

  def evaluate(list, results) do
    x = List.first(list)

    cond do
      x == nil ->
        results

      is_float(x) ->
        evaluate(list |> tl, [x | results])

      true ->
        operand_1 = results |> hd
        operand_2 = results |> tl |> hd
        cond do
          String.equivalent?(x, "+") ->
            y = operand_1 + operand_2
            evaluate(list |> tl, [y | results |> tl |> tl])

          String.equivalent?(x, "-") ->
            y = operand_2 - operand_1
            evaluate(list |> tl, [y | results |> tl |> tl])

          String.equivalent?(x, "*") ->
            y = operand_1 * operand_2
            evaluate(list |> tl, [y | results |> tl |> tl])

          String.equivalent?(x, "/") ->
            y = operand_2 / operand_1
            evaluate(list |> tl, [y | results |> tl |> tl])
        end
    end
  end
end
