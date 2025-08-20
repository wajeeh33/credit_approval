defmodule CreditApprovalApp.Helper do
  alias CreditApprovalApp.PDFGenerator
  alias CreditApprovalApp.EmailService

  @doc """
  Validates the income and expenses values.
  """
  def validate_income_expenses(income, expenses) do
    case {Float.parse(income), Float.parse(expenses)} do
      {{income_float, _}, {expenses_float, _}} ->
        if income_float > 0 and expenses_float >= 0 and income_float > expenses_float do
          {:ok, income_float, expenses_float}
        else
          {:error, "Income must be greater than expenses and both must be positive numbers."}
        end
      _ ->
        {:error, "Please enter valid numbers for income and expenses."}
    end
  end

  @doc """
  Validates the email address.
  """
  def validate_email(email) do
    if String.contains?(email, "@") and String.length(email) > 5 do
      {:ok, email}
    else
      {:error, "Please enter a valid email address."}
    end
  end

  @doc """
  Sends the PDF to the email address.
  """
  def send_pdf(email, data) do
    case PDFGenerator.generate_credit_report(data) do
      {:ok, pdf_path} ->
        EmailService.send_credit_report(email, pdf_path, data)
      {:error, reason} ->
        {:error, "Failed to generate PDF: #{reason}"}
    end
  end

  @doc """
  Formats the currency amount.
  """
  def format_currency(amount) when is_number(amount) do
    :erlang.float_to_binary(amount, decimals: 1)
  end

  def format_currency(_), do: "0.0"

  @doc """
  Formats the answer.
  """
  def format_answer(answer) do
    case answer do
      "yes" -> "Yes"
      "no" -> "No"
      _ -> "Not provided"
    end
  end

  @doc """
  Formats the datetime.
  """
  def format_datetime(datetime) do
    Calendar.strftime(datetime, "%B %d, %Y at %I:%M %p UTC")
  end
end
