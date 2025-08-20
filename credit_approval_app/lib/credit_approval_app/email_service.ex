defmodule CreditApprovalApp.EmailService do
  alias CreditApprovalApp.Helper
  @moduledoc """
  Module for sending credit reports via email using Swoosh.
  """

  @doc """
  Sends a credit report PDF to the specified email address.
  """
  def send_credit_report(email, pdf_path, data) do
    subject = "Your Credit Approval Report - #{if data.points > 6, do: "APPROVED", else: "REVIEW REQUIRED"}"

    attachment = Swoosh.Attachment.new(pdf_path, filename: Path.basename(pdf_path), content_type: "application/pdf")

    %Swoosh.Email{}
    |> Swoosh.Email.to(email)
    |> Swoosh.Email.from({"Credit Approval System", "noreply@creditapproval.com"})
    |> Swoosh.Email.subject(subject)
    |> Swoosh.Email.html_body(generate_email_body(data))
    |> Swoosh.Email.attachment(attachment)
    |> CreditApprovalApp.Mailer.deliver()
    |> case do
      {:ok, _} ->
        File.rm(pdf_path)
        {:ok, "Email sent successfully"}
      {:error, reason} ->
        File.rm(pdf_path)
        {:error, "Failed to send email: #{inspect(reason)}"}
    end
  end

  defp generate_email_body(data) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #2c5aa0; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
        .content { background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; }
        .result { padding: 15px; border-radius: 5px; margin: 20px 0; }
        .approved { background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
        .denied { background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
        .footer { margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; text-align: center; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>Credit Approval Report</h1>
        </div>

        <div class="content">
          <p>Hello,</p>

          <p>Your credit approval application has been processed. Please find your detailed report attached to this email.</p>

          <div class="result #{if data.points > 6, do: "approved", else: "denied"}">
            <h3>Application Status: #{if data.points > 6, do: "APPROVED", else: "REVIEW REQUIRED"}</h3>
            <p><strong>Risk Assessment Score:</strong> #{data.points}/11 points</p>

            #{if data.points > 6 do
              """
              <p><strong>Approved Credit Amount:</strong> $#{Helper.format_currency(data.credit_amount)}</p>
              <p>Congratulations! You have been approved for credit based on your application.</p>
              """
            else
              """
              <p>Thank you for your application. We are currently unable to issue credit to you at this time.</p>
              """
            end}
          </div>

          <p>The attached PDF contains your complete credit approval report with all the details from your application.</p>

          <p>If you have any questions about your application or this report, please don't hesitate to contact our support team.</p>

          <p>Best regards,<br>
          Credit Approval Team</p>
        </div>

        <div class="footer">
          <p>This is an automated message. Please do not reply to this email.</p>
          <p>For support, contact our team at support@creditapproval.com</p>
        </div>
      </div>
    </body>
    </html>
    """
  end
end
