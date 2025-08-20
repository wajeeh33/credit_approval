defmodule CreditApprovalApp.PDFGenerator do
  alias CreditApprovalApp.Helper
  @moduledoc """
  Module for generating PDF credit reports.
  """

  @doc """
  Generates a PDF credit report based on user data.
  """
  def generate_credit_report(data) do
    html_content = generate_html_content(data)

    case PdfGenerator.generate(html_content,
      filename: "credit_report_#{System.system_time()}",
      page_size: "A4",
      margin: "1in"
    ) do
      {:ok, pdf_path} -> {:ok, pdf_path}
      {:error, reason} -> {:error, reason}
    end
  end

  defp generate_html_content(data) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Credit Approval Report</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px; }
        .section { margin-bottom: 25px; }
        .section h2 { color: #2c5aa0; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        .question { margin-bottom: 15px; }
        .question strong { color: #333; }
        .result { background-color: #f0f8ff; padding: 15px; border-radius: 5px; margin: 20px 0; }
        .approved { background-color: #d4edda; border: 1px solid #c3e6cb; }
        .denied { background-color: #f8d7da; border: 1px solid #f5c6cb; }
        .footer { margin-top: 40px; text-align: center; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>Credit Approval Report</h1>
        <p>Generated on #{Helper.format_datetime(DateTime.utc_now())}</p>
      </div>

      <div class="section">
        <h2>Risk Assessment Results</h2>
        <div class="question">
          <strong>Total Points Earned:</strong> #{data.points}/11
        </div>
        <div class="question">
          <strong>Risk Assessment:</strong>
          #{if data.points > 6, do: "APPROVED", else: "DENIED"}
        </div>
      </div>

      <div class="section">
        <h2>Questionnaire Responses</h2>
        <div class="question">
          <strong>Do you have a paying job?</strong> #{Helper.format_answer(data.answers["has_job"])}
        </div>
        <div class="question">
          <strong>Have you consistently had a paying job for the past 12 months?</strong> #{Helper.format_answer(data.answers["job_12_months"])}
        </div>
        <div class="question">
          <strong>Do you own a home?</strong> #{Helper.format_answer(data.answers["owns_home"])}
        </div>
        <div class="question">
          <strong>Do you own a car?</strong> #{Helper.format_answer(data.answers["owns_car"])}
        </div>
        <div class="question">
          <strong>Do you have any additional source of income?</strong> #{Helper.format_answer(data.answers["additional_income"])}
        </div>
      </div>

      #{if data.points > 6 do
        """
        <div class="section">
          <h2>Financial Information</h2>
          <div class="question">
            <strong>Monthly Income:</strong> $#{Helper.format_currency(data.income)}
          </div>
          <div class="question">
            <strong>Monthly Expenses:</strong> $#{Helper.format_currency(data.expenses)}
          </div>
        </div>

        <div class="section">
          <h2>Credit Approval Result</h2>
          <div class="result approved">
            <h3>🎉 Congratulations! You have been approved for credit!</h3>
            <p><strong>Approved Credit Amount:</strong> $#{Helper.format_currency(data.credit_amount)}</p>
            <p>This amount is calculated based on your monthly disposable income multiplied by 12 months.</p>
          </div>
        </div>
        """
      else
        """
        <div class="section">
          <h2>Credit Decision</h2>
          <div class="result denied">
            <h3>Credit Application Status</h3>
            <p>Thank you for your answers. We are currently unable to issue credit to you.</p>
            <p>Your application did not meet the minimum risk assessment requirements.</p>
          </div>
        </div>
        """
      end}

      <div class="footer">
        <p>This report was generated automatically by the Credit Approval System.</p>
        <p>For questions, please contact our support team.</p>
      </div>
    </body>
    </html>
    """
  end
end
