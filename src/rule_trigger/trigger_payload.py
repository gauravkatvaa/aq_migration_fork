import json

def template_payload(row, message, subject):
    payload = {
        'templateName': row['templateName'],
        'language': row['language'],
        'subject': subject,
        'message': message,
        'description': row['description'],
        'category': row['category'],
        'accountId': row['account_id'],
        'notificationType': row['notificationType'],
        'templateType': 'USE_NOTIFICATION_TEMPLATE',
        'attributeString': '',
    }

    return payload


trigger_mapper = {
    'Country or operator change': {
        'rule_category_id': '21',
        'category_name': 'Registration in Zone',
        'default_condition_id': '42',  # Default to '42' if no lambda is provided
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0'
    },
    'Time passed since SIM is in Service Profile': {
        'rule_category_id': '10',
        'category_name': 'Device Plan Change (No. of Days)',
        'default_condition_id': '31',
        'parameter_id': '6',
        'comparator_id': '1',
        'condition_value': '10',  # Default to '10' if no value is provided
        'condition_id': '3',
        'occurrence_count': '1',
        'erval_unit': '2',
        'erval_value': '1',
        'device_plane_id': '0'  # Default to '0' if no value is provided
    },
    'Time passed since First Activity': {
        'rule_category_id': '22',
        'category_name': 'Time passed since First Activity',
        'default_condition_id': '43',
        'parameter_id': '32',  # Default value
        'comparator_id': '0',
        'condition_value': '10',  # Default value
        'condition_id': '36',  # Default value
        'occurrence_count': '0',
        'erval_unit': '10',
        'erval_value': '10'
    },
    'Data Session end': {
        'rule_category_id': '31',
        'category_name': 'Data Session End',
        'default_condition_id': '52',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0'
    },
    'IMEI Mismatch': {
        'rule_category_id': '8',
        'category_name': 'IMEI change',
        'default_condition_id': '29',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0'
    },
    'Inactivity Trigger for Data': {
        'rule_category_id': '9',
        'category_name': 'Data session count',
        'default_condition_id': '30',
        'parameter_id': '13',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '11',
        'occurrence_count': '1',
        'erval_unit': '0',  # Default value if no lambda is provided
        'erval_value': '0'  # Default value if no lambda is provided
    },
    'Other attribute threshold': {
        'rule_category_id': '27',
        'category_name': 'Other Attribute Threshold',
        'default_condition_id': '47',
        'parameter_id': '37',
        'comparator_id': '1',  # Default value if no lambda is provided
        'condition_value': '10',  # Default value if no lambda is provided
        'condition_id': '41',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'device_plane_id': '0'  # Default value if no lambda is provided
    },
    'Session length': {
        'rule_category_id': '35',
        'category_name': 'Session length',
        'default_condition_id': '56',
        'parameter_id': '42',
        'comparator_id': '1',
        'condition_value': '10',  # Default value instead of a lambda
        'condition_id': '46',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0'
    },
    'Volume threshold': {
        'rule_category_id': '2',
        'category_name': 'Usage Monitoring',
        'default_condition_id': '26',
        'parameter_id': '2',
        'comparator_id': '1',
        'condition_value': '10',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '2',
        'erval_value': '20'
    }
}


def trigger_payload(row, user_id, column_mapping, logger_error):
    """
    Generate the payload for creating a trigger in the target system.
    
    Args:
        row (Series): A row from the trigger dataframe
        user_id (str): The user ID to associate with the trigger
        column_mapping (dict): Mapping of column names between systems
        logger_error: Logger for error messages
        
    Returns:
        dict: The payload for the API call
    """
    try:
        # Determine trigger type based on condition type
        condition_type = row.get('CONDITION_TYPE', '')
        
        # Map condition types to trigger names for the mapper
        trigger_condition_map = {
            'TRIGGER_ITEM_CONDITION.VOLUME_THRESHOLD': 'Volume threshold',
            'TRIGGER_ITEM_CONDITION.COST_THRESHOLD': 'Other attribute threshold',
            'TRIGGER_ITEM_CONDITION.POINT_IN_TIME': 'Point in time',
            'TRIGGER_ITEM_CONDITION.INACTIVITY_PERIOD': 'Inactivity Trigger for Data',
            'TRIGGER_ITEM_CONDITION.SP_CHANGE': 'Time passed since SIM is in Service Profile',
            'TRIGGER_ITEM_CONDITION.TIME_PERIOD': 'Time passed since First Activity',
            '17697': 'Country or operator change',
            '17242': 'Session length',
            '17696': 'Data Session end',
            '17241': 'IMEI Mismatch'
        }
        
        trigger = trigger_condition_map.get(condition_type, 'Other attribute threshold')
        
        # Determine trigger category_id and category_name
        category_id = trigger_mapper.get(trigger, {}).get('rule_category_id', '')
        category_name = trigger_mapper.get(trigger, {}).get('category_name', '')
        
        # Get the original application level without any replacement
        original_app_level = (row.get('in_application_level', '') or '')
        # Remove the prefix if it exists
        application_level = original_app_level.replace('TRIGGER_LEVEL.', '')
        
        # Special handling for Session length trigger
        if trigger == 'Session length':
            # For Session length, aggregation level must be SIM
            aggregation_level = 'SIM'
            
            # If application level is SIM, set all_devices to 0 and include IMSI
            if application_level == 'SIM':
                all_devices = '0'
                imsi_from = row.get('imsi_from', '')
                trigger_imsi_from = imsi_from
            # For account level triggers (BU, EC, CC), keep the application level but set aggregation to SIM
            else:
                # Map EC to acceptable levels if needed - EC is not allowed, map to BU
                if application_level == 'EC':
                    application_level = 'BU'
                all_devices = '1'
                imsi_from = ''
                trigger_imsi_from = ''
        else:
            # For other triggers, use standard mapping
            # If app level is SIM, keep as SIM for both levels
            if application_level == 'SIM':
                aggregation_level = 'SIM'
                all_devices = '0'
                imsi_from = row.get('imsi_from', '')
                trigger_imsi_from = imsi_from
            else:
                # For account level triggers, use BU for application and SIM for aggregation
                # Map EC to BU for application level since EC is not accepted
                if application_level == 'EC':
                    application_level = 'BU'
                aggregation_level = 'SIM'  # Always use SIM for aggregation
                all_devices = '1'
                imsi_from = ''
                trigger_imsi_from = ''
        
        # Format webhook_metadata as JSON
        webhook_metadata_value = row.get('webhook_metadata', '')
        webhook_metadata_value = webhook_metadata_value.replace('TRIGGER_ITEM_ACTION.', '')
        webhook_metadata = json.dumps({"action": webhook_metadata_value}) if webhook_metadata_value else '{}'
        
        # Prepare notification metadata
        notification_metadata = []
        if row.get('template_id') and row.get('notificationType'):
            notification_metadata.append({
                "notificationType": row['notificationType'],
                "template_id": row['template_id']
            })
        trigger_metadata = json.dumps(notification_metadata) if notification_metadata else '[]'
        
        # Clean up start_time format (remove milliseconds)
        start_time = row.get('start_time', '')
        if '.' in str(start_time):
            start_time = str(start_time).split('.')[0]
        
        # Build the base payload with common fields and defaults
        payload = {
            'rule_name': row.get('rule_name', ''),
            'account_id': row.get('account_id', ''),
            'rule_category_id': category_id,
            'user_id': user_id,
            'in_application_level': application_level,
            'all_devices': all_devices,
            'rule_erval_unit': '4',
            'rule_erval': '10',
            'in_any_service_profile': '1',
            'start_time': start_time,
            'rule_description': row.get('rule_description', row.get('rule_name', '')),
            'imsi_from': imsi_from,
            'imsi_to': '',
            'default_condition_id': trigger_mapper.get(trigger, {}).get('default_condition_id', ''),
            'parameter_id': trigger_mapper.get(trigger, {}).get('parameter_id', ''),
            'comparator_id': trigger_mapper.get(trigger, {}).get('comparator_id', ''),
            'condition_value': trigger_mapper.get(trigger, {}).get('condition_value', ''),
            'condition_id': trigger_mapper.get(trigger, {}).get('condition_id', ''),
            'occurrence_count': trigger_mapper.get(trigger, {}).get('occurrence_count', '0'),
            'erval_unit': trigger_mapper.get(trigger, {}).get('erval_unit', '0'),
            'erval_value': trigger_mapper.get(trigger, {}).get('erval_value', '0'),
            'action_type_id': row.get('action_type_id', '3'),
            'action_email_id': row.get('action_email_id', ''),
            'action_contact_number': row.get('action_contact_number', ''),
            'changed_service_plane_id': '0',
            'changed_coverage_id': '0',
            'state_change': row.get('state_change', ''),
            'action_subject': '',
            'action_description': '',
            'device_plane_id': '',
            'changed_device_plane_id': '0',
            'webhook_metadata': webhook_metadata,
            'plan_to_id': '',
            'state_from': '',
            'state_to': '',
            'rule_sub_category_id': '',
            'trigger_imsi_from': trigger_imsi_from,
            'in_trigger_metadata': trigger_metadata,
            'languages': '',
            'addon_device_plane_id': '',
            'tag_bit': '0',
            'in_reset_period': '',
            'in_category': 'SimLifecycle',
            'in_rule_access': 'NA',
            'in_raise_alert_json': '{}',
            'in_raise_alert_emailid': '',
            'in_sim_update_in_next_bill_cycle': '',
            'in_sim_next_bill_cycle_change_id': '{"status":"","reason":"","reasonName":""}',
            'in_sim_next_bill_cycle_change': '',
            'in_device_update_in_next_bill_cycle': '0',
            'in_device_next_bill_cycle_change_id': '{"status":"","reason":null}',
            'disconnect_session': '1' if trigger == 'Session length' else '',
            'assign_sim_cost': '',
            'remove_sim_cost': '',
            'in_all_sim_level': '0',
            'in_device_plan': '',
            'in_aggregation_level': aggregation_level,
            'category_name': category_name
        }
        
        # Make sure all values are strings and not lambdas
        for key in payload:
            if callable(payload[key]):
                # If the value is a lambda, replace with default value
                payload[key] = '0'
            elif payload[key] is None:
                payload[key] = ''
            elif not isinstance(payload[key], str):
                payload[key] = str(payload[key])
        
        # Log for debugging
        logger_error.info(f"Generated payload for trigger {trigger}. Rule name: {payload['rule_name']}")
        logger_error.info(f"Application level: {payload['in_application_level']}, Aggregation level: {payload['in_aggregation_level']}")
        
        return payload
    
    except Exception as e:
        logger_error.error(f"Error while generating trigger payload: {e}")
        return None
   

# def template_payload_from_trigger_df(row, message, subject, notification_type):
#     """
#     Create a notification template payload from trigger data.
    
#     Args:
#         row (Series): A row from the trigger dataframe
#         message (str): The message content for the notification
#         subject (str): The subject line for the notification
#         notification_type (str): The type of notification (EMAIL or SMS)
        
#     Returns:
#         str: JSON string payload for the template API
#     """
#     try:
#         payload = {
#             'id': '',
#             'templateName': row['rule_name'],
#             'language': 'en',
#             'subject': subject,
#             'message': message,
#             'description': f'Template created for rule_trigger rule_name {row["rule_name"]}',
#             'category': '',
#             'accountId': row['account_id'],
#             'notificationType': notification_type,
#             'templateType': 'USE_NOTIFICATION_TEMPLATE',
#             'attributeString': '',
#         }

#         # Convert to JSON string
#         return json.dumps(payload)
#     except Exception as e:
#         print(f"Not able to create notification template for trigger: {e}")
#         return {}
        

def template_payload_from_trigger_df(row, message, subject, notification_type):
    """
    Create a notification template payload from trigger data.
    
    Args:
        row (Series): A row from the trigger dataframe
        message (str): The message content for the notification
        subject (str): The subject line for the notification
        notification_type (str): The type of notification (EMAIL or SMS)
        
    Returns:
        str: JSON string payload for the template API
    """
    try:
        # Make sure notification_type is valid
        if not notification_type or notification_type not in ['EMAIL', 'SMS']:
            notification_type = 'EMAIL'  # Default to EMAIL if not specified or invalid
            
        payload = {
            'templateName': f"{row['rule_name']}_{notification_type}",
            'language': 'en',
            'subject': subject,
            'message': message,
            'description': f'Template created for rule_trigger rule_name {row["rule_name"]}',
            'category': 'Text',
            'accountId': row['account_id'],
            'notificationType': notification_type,
            'templateType': 'USE_NOTIFICATION_TEMPLATE',
            'attributeString': '',
        }

        # payload = {
        #     'templateName': row['templateName'],
        #     'language': row['language'],
        #     'subject': subject,
        #     'message': message,
        #     'description': row['description'],
        #     'category': row['category'],
        #     'accountId': row['account_id'],
        #     'notificationType': row['notificationType'],
        #     'templateType': 'USE_NOTIFICATION_TEMPLATE',
        #     'attributeString': '',
        # }


        # Convert to JSON string
        return payload
    except Exception as e:
        return None



'''
    Find dummy payload over here
'''
# def trigger_payload(row, account_id_token, column_mapping, logger_error):
#     """
#     Returns the constant payload for the rule API request.
    
#     Returns:
#         dict: A dictionary containing all the parameters for the rule API request
#     """
#     payload = {
#         'rule_name': 'Demo 1st April',
#         'account_id': '40831',
#         'rule_category_id': '24',
#         'user_id': '2',
#         'in_application_level': 'EC',
#         'all_devices': '1',
#         'rule_erval_unit': '4',
#         'rule_erval': '10',
#         'in_any_service_profile': '1',
#         'start_time': '2025-04-01 13:00:37',
#         'rule_description': 'Demo 123',
#         'imsi_from': '',
#         'imsi_to': ' ',
#         'default_condition_id': '45',
#         'parameter_id': '36',
#         'comparator_id': '0',
#         'condition_value': '2025-04-01 14:00:00',
#         'condition_id': '40',
#         'occurrence_count': '0',
#         'erval_unit': '0',
#         'erval_value': '0',
#         'action_type_id': '11',
#         'action_email_id': '',
#         'action_contact_number': '',
#         'changed_service_plane_id': '0',
#         'changed_coverage_id': '0',
#         'state_change': '',
#         'action_subject': '',
#         'action_description': '',
#         'device_plane_id': '',
#         'in_device_plan_id_for_state_change': '',
#         'changed_device_plane_id': '0',
#         'webhook_metadata': '',
#         'plan_to_id': '',
#         'state_from': '',
#         'state_to': '',
#         'rule_sub_category_id': '',
#         'trigger_imsi_from': '',
#         'in_trigger_metadata': '',
#         'languages': '',
#         'addon_device_plane_id': '',
#         'tag_bit': '0',
#         'in_reset_period': '',
#         'in_category': 'FraudPrevention',
#         'in_rule_access': 'RW',
#         'in_raise_alert_json': '{}',
#         'in_raise_alert_emailid': '',
#         'in_sim_update_in_next_bill_cycle': '',
#         'in_sim_next_bill_cycle_change_id': '{"status":"","reason":"","devicePlanId":"","reasonName":""}',
#         'in_sim_next_bill_cycle_change': '',
#         'in_device_update_in_next_bill_cycle': '',
#         'in_device_next_bill_cycle_change_id': '{"status":"","devicePlanId":""}',
#         'disconnect_session': '1',
#         'assign_sim_cost': '',
#         'remove_sim_cost': '',
#         'in_all_sim_level': '0',
#         'in_device_plan': '',
#         'in_aggregation_level': 'SIM',
#         'category_name': 'Point in Time is Reached'
#     }
    
#     return payload