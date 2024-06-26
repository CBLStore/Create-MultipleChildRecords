/**
 * @description       : This Apex class provides utility methods for dynamically retrieving and converting field types 
 *                      and values for Salesforce objects
 * @author            : Jeyalakshmi
 * @last modified on  : 26-06-2024
 * @last modified by  : Jeyalakshmi
**/
public with sharing class FieldTypeValue {
    public static Schema.SObjectType getObjectType(String objectName) {
        // Get the object type dynamically
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        return objectType;
    }

    public static Schema.DescribeFieldResult getFieldDescribe(String objectName, String fieldName) {
        // Get the object describe dynamically
        Schema.DescribeSObjectResult objectDescribe = getObjectType(objectName).getDescribe();
        
        // Get the field describe dynamically
        Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(fieldName).getDescribe();
        return fieldDescribe;
    }

    public static String getFieldType(String objectName, String fieldName) {
        // Get the field describe dynamically
        Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectName, fieldName);
        
        // Get the field type
        Schema.DisplayType fieldType = fieldDescribe.getType();
        return fieldType.name();
    }

    public static Object convertFieldValue(String objectName, String fieldName, String fieldValue) {
        // Get the field describe dynamically
        Schema.DescribeFieldResult fieldDescribe = getFieldDescribe(objectName, fieldName);
        
        // Get the field type
        Schema.DisplayType fieldType = fieldDescribe.getType();
        system.debug('fieldType :' + fieldType);
        
        // Convert the field value based on field type
        switch on fieldType {
            when BOOLEAN {
                return fieldValue.equalsIgnoreCase('true') || fieldValue.equals('1');
            }
            when DOUBLE {
                return Double.valueOf(fieldValue);
            }
            when INTEGER {
                return Integer.valueOf(fieldValue);
            }
            when CURRENCY {
                return Integer.valueOf(fieldValue);
            }
            when DATE {
                return Date.valueOf(fieldValue);
            }
            when DATETIME {
                return DateTime.valueOf(fieldValue);
            }
            when else {
                // Default to string for unknown types
                return fieldValue;
            }
        }
    }       
}