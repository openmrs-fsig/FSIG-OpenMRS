# Custom Patient Registration

Our instance of OpenMRS is using a custom version of the patient registration application. This allows us to add custom fields to the registration process, such as DPI and Entitad. This was set up following the instructions for [Registration App Configuration](https://openmrs.atlassian.net/wiki/spaces/docs/pages/25470818/Registration+App+Configuration). The file containing our custom app definition is saved here in our github. 

To add a new field to the custom registration, you would first need to create the new field.

1. Navigate to the legacy administration page
2. Select manage person attributes
3. Click on Add new person attribute, add the attribute name and format, and click save
4. Go back to the manage person attributes page and add the name of the new field to all entries of the form under List and View person attributes, and click save
5. Go back to the manage person attributes page, click on your new field, and copy the UUID of the field. This field is partially greyed out and contains a long string of letters and numbers

With the new field created, we need to update our custom registration app to utilize the new field. Update the json file to create a new field section under the config → sections → clinic information section. You can copy one of the existing references and change out the information as needed. For example you could copy this section and replace the legend, label, formFieldName and uuid sections with the name and UUID of your new field. 

```xml
{
    "legend": "Entitad",
    "fields": [
        {
            "type": "personAttribute",
            "label": "Entitad",
            "formFieldName": "entitad",
            "uuid": "023fc5d9-2946-43a3-bde8-ebf0f6c66cdf",
            "widget": {
                "providerName": "uicommons",
                "fragmentId": "field/text"
            }
        }
    ]
},
```

Once this file has been updated, copy its contents and navigate to the OpenMRS home page. Click System Administration → Manage Apps and click the edit pencil icon for the `referenceapplication.registerPatient.MyRegister` app. Delete the existing configuration and paste in the updated file. Click save. 

Now when registering a new patient, the new field should be available in the form.