defmodule Practice.Factor do
  def factor(x) do
    factorize(x, 2, []) |> Enum.sort()
  end

  def factorize(x, divisor, list) do
    cond do
      x < 2 ->
        list
      rem(x, divisor) == 0 ->
        factorize(round(x / divisor), divisor, [divisor | list])
      true ->
        factorize(x, divisor + 1, list)
    end
  end
end
