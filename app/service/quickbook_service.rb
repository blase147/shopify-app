class QuickBooksService
    def self.retrieve_customers
      Quickbooks::Customer.all
    end
end
  