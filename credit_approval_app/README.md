# Credit Approval System

A comprehensive credit approval web application built with Elixir/Phoenix that assesses user creditworthiness through a risk assessment questionnaire and provides automated credit decisions with PDF report generation and email delivery.

## Features

### 🎯 Risk Assessment System
- **5-Question Credit Risk Assessment** with weighted scoring:
  - Do you have a paying job? (4 points)
  - Have you consistently had a paying job for the past 12 months? (2 points)
  - Do you own a home? (2 points)
  - Do you own a car? (1 point)
  - Do you have any additional source of income? (2 points)

### 💳 Credit Calculation
- **Automatic Credit Amount Calculation**: (Monthly Income - Monthly Expenses) × 12
- **Risk-Based Approval**: Users with more than 6 points proceed to credit calculation
- **Real-time Validation**: Input validation for financial data

### 📊 Professional Reporting
- **PDF Report Generation**: Comprehensive credit approval reports
- **Email Delivery**: Automated email with PDF attachment
- **Detailed Analysis**: Complete assessment results and financial summary

### 🎨 Modern User Interface
- **Responsive Design**: Clean, professional interface
- **Step-by-Step Process**: Intuitive user flow
- **Real-time Feedback**: Immediate validation and error handling

## Technology Stack

- **Backend**: Elixir 1.14+ with Phoenix 1.7+
- **Frontend**: Phoenix LiveView with embedded CSS
- **PDF Generation**: pdf_generator library
- **Email Service**: Swoosh with local development mailbox
- **Styling**: Tailwind CSS

## Prerequisites

Before running this application, ensure you have:

- **Elixir 1.14+** and **Erlang/OTP 24+**
- **Node.js 16+** (for asset compilation)
- **wkhtmltopdf** (for PDF generation)

### Installing wkhtmltopdf

#### macOS (using Homebrew):
```bash
brew install wkhtmltopdf
```

#### Ubuntu/Debian:
```bash
sudo apt-get install wkhtmltopdf
```

#### Windows:
Download from [wkhtmltopdf website](https://wkhtmltopdf.org/downloads.html)

## Installation & Setup

### 1. Clone and Navigate
```bash
cd credit_approval_app
```

### 2. Install Dependencies
```bash
mix deps.get
```

### 3. Setup Assets
```bash
mix assets.setup
mix assets.build
```

### 4. Start the Application
```bash
mix phx.server
```

### 5. Access the Application
Open your browser and navigate to: [http://localhost:4000](http://localhost:4000)

## Development Features

### Email Preview
Emails are stored locally and can be viewed at:
- **Mailbox Preview**: [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox)

## Application Flow

### Step 1: Risk Assessment
Users answer 5 questions about their employment, assets, and income sources. The system calculates a risk score out of 11 possible points.

### Step 2: Financial Information (if approved)
Users with more than 6 points provide their monthly income and expenses for credit amount calculation.

### Step 3: Credit Decision
- **Approved**: Users see their approved credit amount and can request a PDF report
- **Denied**: Users receive a clear explanation and can restart the process

### Step 4: Report Generation
Approved users enter their email address to receive a comprehensive PDF report via email.

## Configuration

### Development Environment
The application is configured for development with:
- Local email storage (no external email service required)
- PDF generation using wkhtmltopdf
- Live code reloading and debugging


## LiveView Events

The application uses Phoenix LiveView for real-time interaction. All communication happens through LiveView events:

- `submit_answers` - Processes risk assessment responses
- `submit_income_expenses` - Calculates credit amount
- `send_email` - Generates and sends PDF report
- `restart` - Resets the application state

## File Structure

```
lib/
├── credit_approval_app/
│   ├── points_calculation.ex    # Credit scoring logic
│   ├── pdf_generator.ex         # PDF report generation
│   ├── email_service.ex         # Email delivery service
│   └── mailer.ex               # Mailer configuration
│   └── helper.ex               # helper functions
└── credit_approval_app_web/
    ├── live/
    │   ├── credit_approval_live.ex      # Main LiveView logic
    │   └── credit_approval_live.html.leex # LiveView template
    └── router.ex                         # Application routing
```

## Testing

Run the test suite with:
```bash
mix test
```


## Support

For questions or support, please contact:
- **Email**: support@creditapproval.com
- **GitHub Issues**: Create an issue in this repository

## Changelog

### Version 1.0.0
- Initial release with complete credit approval system
- Risk assessment questionnaire
- Credit amount calculation
- PDF report generation
- Email delivery system
- Modern, responsive UI

---

**Note**: This application is designed for demonstration and educational purposes. For production use in financial services, ensure compliance with relevant regulations and implement appropriate security measures.
