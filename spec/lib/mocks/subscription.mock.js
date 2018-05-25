beforeAll(function() {
    SubscriptionMockery = function() {
        var attrs = attrs || {};
        var data = {"id":"d594600a-87ae-4108-b871-8cde81c60301","project_id":"8f898112-5d69-46b4-aee0-e901287c3575","credit_card_id":null,"paid_count":1,"total_paid":500,"status":"active","paid_at":null,"next_charge_at":"2018-06-09T18:12:27.523232","checkout_data":{"amount": "500", "customer": {"name": "bla", "email": "blah@gmail.com", "phone": {"ddd": "12", "ddi": "12", "number": "123456789"}, "address": {"city": "Blah", "state": "CC", "street": "Rua a", "country": "ASDas", "zipcode": "12345-001", "neighborhood": "daoasd ajsd", "complementary": "asasd", "street_number": "123"}, "document_number": "12345678912"}, "anonymous": false, "payment_method": "boleto", "is_international": false, "credit_card_owner_document": null},"created_at":"2018-05-09T18:12:27.523232","user_id":"bdb1a3d1-7d02-4767-baad-18abdf3be236","reward_id":"87e91728-04ce-41cb-b0e7-d6c3515a7f1e","amount":500,"project_external_id":"8","reward_external_id":"17","user_external_id":"2","payment_method":"boleto","last_payment_id":"9ce52e6b-4ab1-4510-95a1-4a5cee81e585","last_paid_payment_id":"9ce52e6b-4ab1-4510-95a1-4a5cee81e585","last_paid_payment_created_at":"2018-05-09T18:12:27.523232","user_email":"asdasd@gmail.com", "current_paid_subscription":{"amount": 500, "customer": {"name": "dasa sdasd", "email": "asdasd@gmail.com", "phone": {"ddd": "12", "ddi": "23", "number": "12345678912"}, "address": {"city": "asdasdasd", "state": "CC", "street": "asadasdasd", "country": "asdasdasd", "zipcode": "12345-123", "neighborhood": "ASda sdasd", "complementary": "asdasd", "street_number": "123"}, "document_number": "12345678912"}, "anonymous": false, "current_ip": "127.0.0.1", "payment_method": "boleto", "is_international": false},"current_reward_data":{"title": "rec1 QA4", "metadata": null, "row_order": 0, "current_ip": "127.0.0.1", "deliver_at": "2018-05-01", "description": "teste", "minimum_value": 500.0, "shipping_options": "free", "maximum_contributions": 0},"current_reward_id":"87e91728-04ce-41cb-b0e7-d6c3515a7f1e","updated_at":"2018-05-09T18:12:27.523232"};
        data = _.extend(data, attrs);
        return [data];
    };

    jasmine.Ajax.stubRequest(new RegExp("("+apiPrefix + '\/subscriptions)'+'(.*)')).andReturn({
        'responseText' : JSON.stringify(SubscriptionVersionMockery())
    });
});


 
