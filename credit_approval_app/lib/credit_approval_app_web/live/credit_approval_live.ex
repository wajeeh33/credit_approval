defmodule CreditApprovalAppWeb.CreditApprovalLive do
  use Phoenix.LiveView
  alias CreditApprovalApp.PointsCalculation
  alias CreditApprovalApp.Helper

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      step: 1,
      points: 0,
      income: nil,
      expenses: nil,
      email: nil,
      answers: %{},
      credit_amount: nil,
      error_message: nil
    )}
  end

  def handle_event("submit_answers", %{"answers" => answers}, socket) do
    points = PointsCalculation.calculate_points(answers)

    if points > 6 do
      {:noreply, assign(socket, step: 2, points: points, answers: answers)}
    else
      {:noreply, assign(socket, step: 3, points: points, answers: answers)}
    end
  end

  def handle_event("submit_income_expenses", %{"income" => income, "expenses" => expenses}, socket) do
    case Helper.validate_income_expenses(income, expenses) do
      {:ok, income_float, expenses_float} ->
        credit_amount = PointsCalculation.calculate_credit_amount(income, expenses)
        {:noreply, assign(socket,
          step: 4,
          credit_amount: credit_amount,
          income: income_float,
          expenses: expenses_float
        )}
      {:error, message} ->
        {:noreply, assign(socket, error_message: message)}
    end
  end

  def handle_event("send_email", %{"email" => email}, socket) do
    case Helper.validate_email(email) do
      {:ok, _} ->
        case Helper.send_pdf(email, socket.assigns) do
          {:ok, _} ->
            {:noreply, assign(socket, step: 5, email: email, error_message: nil)}
          {:error, message} ->
            {:noreply, assign(socket, error_message: message)}
        end
      {:error, message} ->
        {:noreply, assign(socket, error_message: message)}
    end
  end

  def handle_event("restart", _params, socket) do
    {:noreply, assign(socket,
      step: 1,
      points: 0,
      income: nil,
      expenses: nil,
      email: nil,
      answers: %{},
      credit_amount: nil,
      error_message: nil
    )}
  end
end
