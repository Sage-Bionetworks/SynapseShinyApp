Basic Shiny application for use on Sage Bionetwork's Synapse web portal.

## Credits

- Author: [duncan-palmer](https://github.com/duncan-palmer)
- Contributors: [kdaily](https://github.com/kdaily)

## Introduction

Shiny applications are a powerful way to develop interactive data visualization and manipulation interfaces. However, when using with Synapse, user authentication is an issue - whomever the Shiny application is running as will determine the access that users visiting the application will have.

This solution allows to determine which user is currently logged into Synapse through the web browser. These credentials are passed on to the Shiny app, and that specific user is logged in. Subsequent interactions with Synapse to pull data for the Shiny interface then happens as that user.

## Usage

To create a new Shiny application based on this structure, do *not* fork this repository directly on GitHub. Instead, please use GitHub's importer following the instructions [below](#creating-a-repository).
 
### Creating a New Shiny App Repository

1.  Go to [GitHub's importer](http://import.github.com/new?import_url=https://github.com/Sage-Bionetworks/SynapseShinyApp.git) and paste in this repository's clone URL (https://github.com/Sage-Bionetworks/SynapseShinyApp.git).
1.  Choose a name for your repository.
1.  Select the owner for your repository (This will probably be you, but may instead be an organization you belong to).

You can now click "Begin Import". When the process is done, you can click "Continue to repository" to visit your newly-created repository.

### Notes

If you are using a `navbarPage` instead of a `fluidPage` in your `ui.R`, use of this code: 
```tags$head(
    singleton(
      includeScript("www/readCookie.js")
    )
  ),
``` 
will cause create a default ghost tab. Instead, you should replace the above code with this snippet: 
```
header=list(tags$head(includeScript("www/readCookie.js"))),
```
