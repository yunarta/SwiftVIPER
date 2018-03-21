/*:
 ## VIPER for UIKitTable
 
 ### Concept
 
 While VIPER can be understood and implemented easily for UIViewController, applying the same concept for UIKit Table is more challenging and it may be confusing until you grasp the intention and contract.
 
 **Classical modelling**
 
 In classical UIKit modelling, a table view will mostly consists of 4 main elements which are:
 
 - UITableView
 The user interface component where the table will be rendered. This mostly not modified when working with table view.
 
 - UITableViewDataSource
 The data provider for table view, provides number of section, and row and provides which UITableViewCell should be used for specific row and populates the data into the UITableViewCell
 
 - UITableViewDelegate
 The user interface render and action handler, mostly used for providing the estimated and exact height of a cell, and receiving tap actions
 
 - UITableViewCell
 The user interface component where the cell will be rendered. This component will contains other UIView components, and child components action will be handled by the UITableViewCell directly
 
 While this seems benign in first place, it does not really fit into MVVM scenario, or even VIPER. In most implementation that can be found, developer tends to conforming UITableViewDataSource and UITableViewDelegate into one class.
 
 > And to make it even worse, even Apple UITableView examples will suggests that UITableViewDataSource and UITableViewDelegate to be conformed onto UIViewController.
 
 And for a mixed cell type table view, the separation is usually done by creating more function or just having the population code placed in one method.
 
 **Proposal**
 
 In contrasts to UIKit modelling, in VIPER we are aiming to have the same clear separation to what we have learned in VIPER for UIKit. Before we begin, let me explain the intention and direction that we wanted with table view.
 
 - Testability of table cell view
 - Therefore each cell should responsible for rendering and handling their own data
 - Then data source responsibility is changed to only providing data structure and cell identifier

*/
