class QuickBooksService
    def self.retrieve_customers
      Quickbooks::Customer.all
    end
  
    # Add other methods for interacting with QuickBooks' API as needed
  end
  