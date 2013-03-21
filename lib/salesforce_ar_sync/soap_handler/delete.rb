module SalesforceArSync
  module SoapHandler
    class Delete < SalesforceArSync::SoapHandler::Base
       def process_notifications(priority = 90)
         batch_process do |sobject|
           SalesforceArSync::SoapHandler::Delete.async_delete_object(sobject, priority)
         end
       end

       def self.delete_object(hash = {})
         raise ArgumentError, "Object_Id__c parameter required" if hash[namespaced(:Object_Id__c)].blank?
         raise ArgumentError, "Object_Type__c parameter required" if hash[namespaced(:Object_Type__c)].blank?
     
         object = hash[namespaced(:Object_Type__c)].constantize.find_by_salesforce_id(hash[namespaced(:Object_Id__c)])
         object.destroy if object
       end

       def self.async_delete_object(hash = {}, priority = 90)
         delay(:priority => priority, :run_at => 5.seconds.from_now).delete_object(hash)
       end
    end
   end
 end