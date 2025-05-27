import json

def template_payload(row,message,subject):
    payload = {
        'id':row['id'],
        'templateName':row['templateName'],
        'language':row['language'],
        'subject':subject,
        'message':message,
        'description':row['description'],
        'category':row['category'],
        'accountId':row['account_id'],
        'notificationType':row['notificationType'],
        'templateType':row['templateType'],
        'attributeString':row['attributeString'],
    }
    return payload



def do_not_use_template_payload(row,message,subject,notification_type):
    payload = {
        'id':row['id'],
        'templateName':'',
        'language':'',
        'subject':subject,
        'message':message,
        'description':'',
        'category':'',
        'accountId':row['account_id'],
        'notificationType':notification_type,
        'templateType':'DO_NOT_USE_NOTIFICATION_TEMPLATE',
        'attributeString':'',
    }
    return payload

# def update_payload(payload, row):
#     # Check if TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE_MAIL_TEMPLATE is null or empty
#     if not row.get('TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE_MAIL_TEMPLATE'):
#         # Case 1 & Case 2: Update or add keys email_id, email_msg, and email_subject
#         payload['email_id'] = row.get('action_email_id', '')
#         payload['email_msg'] = row.get('TRIGGER_ITEM_ACTION_SEND_MAIL_MESSAGE', '')
#         payload['email_subject'] = row.get('TRIGGER_ITEM_ACTION_SEND_MAIL_SUBJECT', '')

#     return payload

trigger_mapper = {
     '17697': {
        'rule_category_id': '8',
        # 'category_name':'IMEI change',
        'default_condition_id': '29',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : ''
    },
    '17696': {
        'rule_category_id': '21',
        # 'category_name':'Registration in Zone',
        'default_condition_id':'42',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : lambda row, col_map: row[col_map['TIC_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT']] # -> TRIGGER_ITEM_CONDITION_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT column value will come in this
    },
    'Network/Operator change': {
        'rule_category_id': '21',
        # 'category_name':'Registration in Zone',
        'default_condition_id':'42',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : lambda row, col_map: row[col_map['TIC_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT']]  # -> TRIGGER_ITEM_CONDITION_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT column value will come in this
    },
    '17242': {
        'rule_category_id': '13',
        # 'category_name':'Device Plan Change (No. of Days)',
        'default_condition_id': '34',
        'parameter_id': '14',
        'comparator_id': '3',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '1',
        'erval_unit': '1',
        'erval_value': '1',
        'in_aggregation_level':'SIM',
        'device_plane_id' : lambda row, col_map: row[col_map['TIC_SP_CHANGE_SERVICE_PROFILE_CONTEXT']], # -> TRIGGER_ITEM_CONDITION_SP_CHANGE_SERVICE_PROFILE_CONTEXT column value will come in this 
        'plan_to_id':'ANY',
        'in_any_service_profile':'',
        'in_device_plan' : ''
    },

    'TRIGGER_ITEM_CONDITION.POINT_IN_TIME': {
        'rule_category_id': '24',
        # 'category_name':'Device Plan Change (No. of Days)',
        'default_condition_id': '45',
        'parameter_id': '36',
        'comparator_id': '0',
        'condition_value': lambda row, col_map: row[col_map['TIC_POINT_IN_TIME_TIME']], # TRIGGER_ITEM_CONDITION_POINT_IN_TIME_TIME column value will come in this
        'condition_id': '40',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'SIM',
        'device_plane_id' : '',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : ''
    },

    '17241': {
        'rule_category_id': '22',
        # 'category_name':'Time passed since First Activity',
        'default_condition_id': '43',
        'parameter_id': lambda row,col_map: ','.join(filter(None, [
        '32' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_DATA']] == '1' else '',
        '33' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_SMS']] == '1' else '',
        '34' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_VOICE']] == '1' else ''])),
        'comparator_id': '0',
        'condition_value': lambda row, col_map: row[col_map['TIC_TIME_PERIOD_FIRST_ACTIVITY_NUMBER_OF_DAYS']],
        'condition_id': lambda row,col_map: ','.join(filter(None, [
        '36' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_DATA']] == '1' else '',
        '37' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_SMS']] == '1' else '',
        '38' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_VOICE']] == '1' else ''])),
        'occurrence_count': '0',
        'erval_unit': '10',
        'erval_value': '10',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : lambda row, col_map: row[col_map['TRIGGER_ITEM_CONDITION_POINT_IN_TIME_TIME']]
    },
    
    'TRIGGER_ITEM_CONDITION.SP_CHANGE': {
        'rule_category_id': '10',
        # 'category_name':'Device Plan Change (No. of Days)',
        'default_condition_id': '31',
        'parameter_id': '6',
        'comparator_id': '1',
        'condition_value': lambda row, col_map: row[col_map['TIC_TIME_PERIOD_SIM_IN_SP_NUMBER_OF_DAYS']],
        'condition_id': '3',
        'occurrence_count': '1',
        'erval_unit': '2',
        'erval_value': '1',
        'in_aggregation_level':'SIM',
        'device_plane_id' : lambda row, col_map: row[col_map['TIC_TIME_PERIOD_SIM_IN_SP_SERVICE_PROFILE_CONTEXT']], # -> TRIGGER_ITEM_CONDITION_SP_CHANGE_SERVICE_PROFILE_CONTEXT column value will come in this 
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : ''
    },

    ## Confirmation Stiil pending 

    'TRIGGER_ITEM_CONDITION.VOLUME_THRESHOLD': {
        'rule_category_id': '12',
        # 'category_name':'Data Session End',
        'default_condition_id': '33',
        'parameter_id': '16',
        'comparator_id': '1',
        'condition_value': '55',
        'condition_id': '50',
        'occurrence_count': '1',
        'erval_unit': '1',
        'erval_value': '1',
        'in_aggregation_level':'',
        'device_plan_id':lambda row, col_map: row[col_map['TIC_VOLUME_THRESHOLD_SERVICE_PROFILE_CONTEXT']],
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : ''
    },

    ## Confirmation Stiil pending
    'TRIGGER_ITEM_CONDITION.COST_THRESHOLD': {
        'rule_category_id': '36',
        # 'category_name':'Data Session End',
        'default_condition_id': '57',
        'parameter_id': '44',
        'comparator_id': '4',
        'condition_value': '50',
        'condition_id': '48',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'',
        'device_plan_id':lambda row, col_map: row[col_map['TIC_COST_THRESHOLD_SERVICE_PROFILE_CONTEXT']],
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : ''
    },

    ## Mapping is Pending
    'TRIGGER_ITEM_CONDITION.INACTIVITY_PERIOD': {
        'rule_category_id': '2',
        # 'category_name':'Usage Monitoring',
        'default_condition_id': '26',
        'parameter_id': lambda row,col_map: ','.join(filter(None, [
        '2' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_DATA']] == '1' else '',
        '9' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_SMS']] == '1' else '',
        '10' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_VOICE']] == '1' else ''])),
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': lambda row,col_map: ','.join(filter(None, [
        '36' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_DATA']] == '1' else '',
        '37' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_SMS']] == '1' else '',
        '38' if row[col_map['TIAA_CONDITION_TIME_PERIOD_FIRST_ACTIVITY_VOICE']] == '1' else ''])),
        'occurrence_count': '0',
        'erval_unit': '10',
        'erval_value': '10',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : lambda row, col_map: row[col_map['TIC_POINT_IN_TIME_TIME']]
    }
   
    
}

country_operator_change_trigger = {
    '17692': {
        'rule_category_id': '21',
        # 'category_name':'Registration in Zone',
        'default_condition_id':'42',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : lambda row, col_map: row[col_map['TIC_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT']] # -> TRIGGER_ITEM_CONDITION_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT column value will come in this
    },

    '17691': {
        'rule_category_id': '21',
        # 'category_name':'Registration in Zone',
        'default_condition_id':'46',
        'parameter_id': '0',
        'comparator_id': '0',
        'condition_value': '0',
        'condition_id': '0',
        'occurrence_count': '0',
        'erval_unit': '0',
        'erval_value': '0',
        'in_aggregation_level':'SIM',
        'device_plan_id':'',
        'plan_to_id':'',
        'in_any_service_profile':'',
        'in_device_plan' : lambda row, col_map: row[col_map['TIC_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT']] # -> TRIGGER_ITEM_CONDITION_COUNTRY_OR_OPERATOR_CHANGE_SERVICE_PROFILE_CONTEXT column value will come in this
    },
}

# Define the trigger_payload function
def trigger_payload(row,user_id, column_mapping,logger_error):
    # Extract necessary columns using provided column mapping
    try:
      trigger = row[column_mapping['Trigger']]
      trigger_metadata = [{"notification_type":row['notificationType'],"template_id":row['template_id']}]
      trigger_metadata = json.dumps(trigger_metadata)
      print('trigger data',trigger_metadata)

      trigger_country_operator_change = row[column_mapping['TIC_COUNTRY_OR_OPERATOR_CHANGE_CHANGE_TYPE']]
      # Initialize the payload with common fields
      payload = {
          'rule_name':row['rule_name'],
          'account_id':row['account_id'],
          'rule_category_id':'',
          'user_id':user_id,
          'in_application_level':row['in_application_level'],
          'all_devices':row['all_devices'],
          'rule_erval_unit':'4',
          'rule_erval':'10',
          'in_any_service_profile':row['in_any_service_profile'],
          'start_time':row['start_time'],
          'rule_description':row['rule_description'],
          'imsi_from':row['imsi_from'],
          'imsi_to':'',
          'default_condition_id':'',
          'parameter_id':'',
          'comparator_id':'',
          'condition_value':'',
          'condition_id':'',
          'occurrence_count':'',
          'erval_unit':'',
          'erval_value':'',
          'action_type_id':row['action_type_id'],
          'action_email_id':row['action_email_id'],
          'action_contact_number':row['action_contact_number'],
          'changed_service_plane_id':'0',
          'changed_coverage_id':'0',
          'state_change':row['state_change'],
          'action_subject':'',
          'action_description':'',
          'device_plane_id':'',
          'changed_device_plane_id':row['new_device_plane_id'] if trigger=='Time passed since SIM is in Service Profile' else '',
          'webhook_metadata':'',
          'plan_to_id':'',
          'state_from':'',
          'state_to':'',
          'rule_sub_category_id':'',
          'trigger_imsi_from':'',
          'in_trigger_metadata':trigger_metadata if row['template_id']!='' else '',    ## [{"notification_type":"Email","template_id":79}]
          'languages':'',
          'addon_device_plane_id':'',
          'tag_bit':'0',
          'in_reset_period':row['in_reset_period'],
          'in_category':row['in_category'],
          'in_rule_access':'',
          'in_raise_alert_json':'{}',
          'in_raise_alert_emailid':'',
          'in_sim_update_in_next_bill_cycle':'',
          'in_sim_next_bill_cycle_change_id':'{"status":"","reason":"","reasonName":""}',
          'in_sim_next_bill_cycle_change':'',
          'in_device_update_in_next_bill_cycle':row['in_device_update_in_next_bill_cycle'],
          'in_device_next_bill_cycle_change_id':'{"status":"","reason":null}',
          'disconnect_session':'',
          'assign_sim_cost':'',
          'remove_sim_cost':'',
          'in_all_sim_level':'0',
          'in_device_plan':'',
          'in_aggregation_level':row['in_aggregation_level'],
          'category_name':''
      }
      # Fetch the specific trigger details from the mapper
      if trigger in trigger_mapper:
          trigger_details = trigger_mapper[trigger]
          # Update payload with trigger details, evaluating lambdas if necessary
          for key, value in trigger_details.items():
              if callable(value):
                  payload[key] = value(row, column_mapping)
              elif value in column_mapping and column_mapping[value] in row:
                  payload[key] = row[column_mapping[value]]
              else:
                  payload[key] = value

     if trigger in trigger_country_operator_change:
          trigger_details = trigger_country_operator_change[trigger]
          # Update payload with trigger details, evaluating lambdas if necessary
          for key, value in trigger_details.items():
              if callable(value):
                  payload[key] = value(row, column_mapping)
              elif value in column_mapping and column_mapping[value] in row:
                  payload[key] = row[column_mapping[value]]
              else:
                  payload[key] = value

      return payload
      
    
    except Exception as e:
       logger_error.error("Error while generating payload : {}".format(e))
