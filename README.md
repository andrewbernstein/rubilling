# rubilling
A Rails Billing Service

## Goals

Create a simple Rails billing service that is interacted with through JSON APIs to be able to handle virtually any billing situation.

Avoid complicated design patterns to increase readability and understandability while following (largely) standard Ruby on Rails conventions:
- Service classes for re-useable units of business logic
-- Author's note: IMO, this is a missing concept in base Rails that would significantly decrease complexity of Rails apps
- Sidekiq for asynchronous processing (?)
-- Author's note: for simplicity, it's probably worth looking into the newer Rails async processing paradigms, but Sidekiq has been rock solid
- No engines
-- Author's note: as cool as engines have the potential to be, they end up having all of the downsides of Rails monoliths with all of the downsides of microservices
- Rspec for tests
-- Author's note: I like the relative power and simplicity of RSpec
- No AI-generated pull requests or code
-- Author's note: this isn't intended to be a knee-jerk "AI IS BAD" hot take, but there are a lot of unresolved IP ownership issues and cost/effectiveness issues and I don't want to handle that right now

## Data Structures

### Invoices
Analogous to the bill you receive at a restaraunt.

An Invoice HAS MANY Line Items
An Invoice HAS MANY Adjustments THROUGH Line Items
An Invoice HAS MANY Transactions
- Author's note: most Invoices will only have one Transaction, even if you allow partial payments of Invoices
An Invoice HAS MANY Payor Entities
- In the Restaraunt analogy, this is the Customer
An Invoice HAS MANY Payee Entities
- In the Restaraunt analogy, this is the Restaraunt

### Line Items
Analogous to an individual item on the bill you receive at a restaraunt.

A Line Item BELONGS TO an Invoice
A Line Item HAS MANY Adjustments

### Adjustments
A breakdown of the billing parts of each individual line item on an invoice, there isn't a great simple analogy.

An Adjustment BELONGS TO an Invoice
An Adjustment BELONGS TO a Line Item
An Adjustment BELONGS TO an Applied Transaction
- Author's note: most Adjustments won't belong to an Applied Transaction, but payment Adjustments will
An Adjustment BELONGS TO a Trasaction THROUGH an Applied Transaction
- Author's note: similar to Applied Transactions, most adjustments won't belong to a Transaction

### Transactions
Charges on the bill you receive at a restaraunt.

This is an internal representation of a payment received from a 

A Transaction HAS MANY Applied Transactions
A Transaction HAS MANY Invoices THROUGH Applied Transactions
A Transaction HAS MANY Adjustments THROUGH Applied Transactions
A Transaction HAS ONE Payor Entity
A Transaction HAS ONE Payee Entity

### Applied Transactions
The link between a Transaction and an Invoice that lets you partially pay an Invoice, or (potentialy) pay multiple Invoices with a single Transaction. 

If an invoice has been paid (partially or fully), it will have at least one Applied Transaction with a link to the Transaction representation of the payment.

Under the hood, this is functionally a join table between Invoices and Transactions.

An Applied Transaction BELONGS TO an Invoice
An Applied Transaction BELONGS TO a Transaction

### Entity
You, a customer of your business, or a vendor that you need to pay.

Entity 1 should be you (your company) who is receiving money from customers or paying out to vendors.

An Entity HAS MANY Invoices
An Entity HAS MANY Payor Transactions
An Entity HAS MANY Payee Transactions