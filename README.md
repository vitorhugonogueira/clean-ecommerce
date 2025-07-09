# clean_ecommerce

A Flutter project of an e-commerce prototype applying Clean Architecture principles.

_You can read this document in Portuguese [here](README_PT.md)_.

## Scope

- To realize product listing, details and cart control.
- To approach use cases that can bring complexity (business rules) to the front-end:
    - **Stock control considering the current cart** (not persisted remotely).
    - **Conditional navigation control** (Ex: to navigate to cart page or stay at details after adding item to cart).
    - **Error handling**.

## Introduction

With the **hardware evolution** of our time, the processing capacity of frontend apps increases. This led us to build apps more and more powerful on front, with hard rules of state management, theme and special functions controlled exclusively on the front-end. But, as every virtue has its price, a lot of our apps became too complex and not very scalable. Not to mention the struggle of writing unit tests combined to our components and screens.

Based on my experience on front (7 years) and what I have learned with Clean Architecture (Uncle Bob) and applying in real projects, I'd like to propose this **software design** as a way to light and scalable development on front/mobile.

## Architecture

The Clean Architecture proposes a concentric layers structure with a rule to the dependence direction. Everything is done so that the code be testable. We know this and if you aren't aware you can search more about this architectural proposal. However, we also know the risks: the feared **OVER ENGINEERING**. Yes, this is fact and when we tried to apply clean arch with all those layers with a team in a real project, the things didn't work well.

For this reason, I want to leave a simplified proposal here, that removes the need (rule) to separate the layers contained in the domain: Entities and Use Cases. By "rule" we mean it will not be mandatory, there will be no architectural limit between the domain structs: Entities and Use Cases. That doesn't prevent to separate concerns and seek, as **good practice**, that use cases depend on entities, not the other way around.

Furthermore, the "Interface Adapters" (presenters/gateways) are divided into abstractions in domain and concrete classes in UI (Frameworks and Drivers). So that our application will be **just one architectural limit**: Domain <> Frameworks and Drivers.

In this way we don't need to create DTO or ViewModel classes for entities (for not being able to access entities directly from screen) which makes the process very costly, especially in frontend context. Still, we have not lost the testability and the fully **domain independence**: where will be all business rules. This opens up space for others complex front rules: UI rules (screen constraints, theme rules, conditionals for operating systems) and Data Rules (backend data mapping). To separate the business rules improves the organization, makes the code testable and makes it easier to understand the rules of UI and Data:

![Architecture](/architecture.jpg "Architecture")

### UI/Data

- These are two sectors of "Frameworks and Drivers" layer. Here we can call them "layers" for make it easier, even understanding that they are on same level - side by side.
- It means UI and Data know each other. And it do not mean that screens shoud use directily datasources to get products to fill a list. But it means the screen knows where the information came from and is able to pass to domain what it don't know (which repository it can use to obtain products). In other words, the screen knows the datasource just to pass by parameter to the use case - respecting the separation of concerns.

### Domain

- Contains all business rules - use cases / entities.
- Contains all the abstraction of the outside world:
    - Gateways (dialog/navigator)
    - Repositories.
    - Presenters/States.