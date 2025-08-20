defmodule CreditApprovalApp.PointsCalculation do
  @moduledoc """
  Module for calculating credit approval points and credit amounts.
  """

  @doc """
  Calculates total points based on user answers to risk assessment questions.

  ## Questions and Points:
  - Do they have a paying job (4 points)
  - Did they consistently have a paying job for past 12 months (2 points)
  - If they own a home (2 points)
  - If they own a car (1 point)
  - Do they have any additional source of income (2 points)
  """
  def calculate_points(answers) do
    points = 0

    points = if answers["has_job"] == "yes", do: points + 4, else: points
    points = if answers["job_12_months"] == "yes", do: points + 2, else: points
    points = if answers["owns_home"] == "yes", do: points + 2, else: points
    points = if answers["owns_car"] == "yes", do: points + 1, else: points
    points = if answers["additional_income"] == "yes", do: points + 2, else: points

    points
  end

  @doc """
  Calculates approved credit amount based on monthly income and expenses.
  Formula: (income - expenses) * 12
  """
    def calculate_credit_amount(income, expenses) do
    income_float = parse_number(income)
    expenses_float = parse_number(expenses)

    (income_float - expenses_float) * 12
  end

  defp parse_number(str) when is_binary(str) do
    case Float.parse(str) do
      {float, _} -> float
      :error ->
        case Integer.parse(str) do
          {int, _} -> int * 1.0
          :error -> 0.0
        end
    end
  end

  defp parse_number(num) when is_number(num), do: num * 1.0
end
