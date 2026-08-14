# rubilling
A Rails Billing Service

## Goals

Create a simple Rails billing service that is interacted with through JSON APIs to be able to handle virtually any billing situation.

Data models and API calls should all provide monitorable and validatable data sources to (ideally) ensure that errors are not happening and (if they do happen) as much data as possible to quickly identify and solve bugs.

Avoid complicated design patterns to increase readability and understandability while following (largely) standard Ruby on Rails conventions:
- Service classes for re-useable units of business logic
    - Author's note: IMO, this is a missing concept in base Rails that would decrease complexity of Rails apps
- Sidekiq for asynchronous processing (?)
    - Author's note: for simplicity, it's probably worth looking into the newer Rails async processing paradigms, but Sidekiq has been rock solid
- No engines
    - Author's note: as cool as engines have the potential to be, they end up having all of the downsides of Rails monoliths with all of the downsides of microservices
- Rspec for tests
    - Author's note: I like the relative power and simplicity of RSpec
- No AI-generated pull requests or code
    - Author's note: this isn't intended to be a knee-jerk "AI IS BAD" hot take, but there are a lot of unresolved IP ownership issues and cost/effectiveness issues and I don't want to handle that right now
- Don't use `attr_accessor` over `@` unless you need to access class values from outside of that class
    - Author's note: `@` is fewer keystrokes than `attr_accessor` and is clear that it's an instance value over being a local variable or method

## Data Structures

### Invoices
Analogous to the bill you receive at a restaraunt.

- An Invoice HAS MANY Line Items
- An Invoice HAS MANY Adjustments THROUGH Line Items
- An Invoice HAS MANY Transactions
    - Author's note: most Invoices will only have one Transaction, even if you allow partial payments of Invoices
- An Invoice HAS MANY Payor Entities
    - In the Restaraunt analogy, this is the Customer
- An Invoice HAS MANY Payee Entities
    - In the Restaraunt analogy, this is the Restaraunt

### Line Items
Analogous to an individual item on the bill you receive at a restaraunt. The `amount_in_cents` of the Line Item's `BASE_PRICE` Adjustment is determined by its Variant's `amount_in_cents` multiplied by the Line Item's Quantity.

- A Line Item BELONGS TO an Invoice
- A Line Item HAS MANY Adjustments
- A Line Item HAS ONE Variant

### Adjustments
A breakdown of the billing parts of each individual line item on an invoice, there isn't a great simple analogy.

- An Adjustment BELONGS TO an Invoice
- An Adjustment BELONGS TO a Line Item
- An Adjustment BELONGS TO a Variant THROUGH Line Items
    - Author's note: most Adjustments won't belong to a Variant, but BASE Adjustments will
- An Adjustment BELONGS TO an Applied Transaction
    - Author's note: most Adjustments won't belong to an Applied Transaction, but PAYMENT Adjustments will
- An Adjustment BELONGS TO a Trasaction THROUGH an Applied Transaction
    - Author's note: similar to Applied Transactions, most adjustments won't belong to a Transaction

### Transactions
Charges on the bill you receive at a restaraunt.

This is an internal representation of a payment received from a payor Entity (the Entity paying the Invoice) to a payee Entity (the Entity receiving the money). 

- A Transaction HAS MANY Applied Transactions
- A Transaction HAS MANY Invoices THROUGH Applied Transactions
- A Transaction HAS MANY Adjustments THROUGH Applied Transactions
- A Transaction HAS ONE Payor Entity THROUGH Payment Methods
- A Transaction HAS ONE Payee Entity
- A Transaction HAS ONE Payment Method

### Applied Transactions
The link between a Transaction and an Invoice that lets you partially pay an Invoice, or (potentialy) pay multiple Invoices with a single Transaction. 

If an invoice has been paid (partially or fully), it will have at least one Applied Transaction with a link to the Transaction representation of the payment.

Under the hood, this is functionally a join table between Invoices and Transactions.

- An Applied Transaction BELONGS TO an Invoice
- An Applied Transaction BELONGS TO a Transaction
- An Applied Transaction BELONGS TO a Payment Method THROUGH its Transaction

### Entity
You, a customer of your business, or a vendor that you need to pay.

Entity 1 should be you (your company) who is receiving money from customers or paying out to vendors.

- An Entity HAS MANY Invoices
- An Entity HAS MANY Payor Transactions THROUGH Transactions
- An Entity HAS MANY Payee Transactions
- An Entity HAS MANY Payment Methods

### Product
An the product being billed for. Analogous to a type of item on the menu that has variations, like a hamburger

- A Product HAS MANY Variants

### Variant
The individual type of product that is billed for. Analogous to a veggie burger vs. a regular burger. The variant has the base price (`amount_in_cents`) of the line item.

- A Variant BELONGS TO a Product

### Payment Method
The method an entity uses to pay for 

### Log
Logs are not directly a billing object, but there should be a Log for each action (API call received, asynchronous job called, Service class called, etc.) performed by rubilling to be able to view a history of each call to allow us to validate that each call is performed properly and identify when and where issues occurred.

Please note that these logs are not intended to replace monitoring calls like Datadog or other services, but are designed to provide direct links to models as necessary, store API call parameters, and (potentially) provide a queryable call stack all to aid debugging by reconstructing calls and provide another validation source.

Every call to an API endpoint, Service class, or other unit of logic should create a Log object with a reference to the parent Log (if applicable, calls to API endpoints and periodic asynchronous jobs will likely not have this), the name of the class that is currently being called, parameters, and a status field that gets updated as desired.