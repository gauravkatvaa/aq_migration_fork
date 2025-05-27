'''
Roam Zone extraction
'''
import json

def check_uom(uom):
    uom_mapping = {
        "mb": "1",
        "gb": "2",
        "kb": "3",
        "minutes": "4",
        "tb": "5",
        "seconds": "6"
    }
    return uom_mapping.get(uom.lower(), "0") if uom else "0"

def extract_prices_for_roam(data, base_charge):
    prices = []
    base_charge_list = []

    # Iterate over the zones in the data
    for zone in data.get('data', {}).get('data', {}).get('zone', []):
        # Iterate over products in each zone
        if zone.get('zone_type') == "ROAM":
          for product in zone.get('product', []):
              if product.get('product_type', '').lower() == "nbiot":
                  for pricing_spec in product.get('pricingSpecs', []):
                      prd = json.loads(product.get('prd_characteristics', '{}'))
                      price = {
                          "serviceType": f"Roam Data NbIoT{' - ' + prd.get('subService') if prd.get('subService') else ''}",
                          "price": str(pricing_spec.get('price')),
                          "currency": pricing_spec.get('currency_code'),
                          "unit": check_uom(pricing_spec.get('uom')),
                          "zone_name": zone.get('zone_name')
                      }
                      prices.append(price)

              elif product.get('product_type', '').lower() == "data":
                  for pricing_spec in product.get('pricingSpecs', []):
                      prd = json.loads(product.get('prd_characteristics', '{}'))
                      price = {
                          "serviceType": f"{zone.get('zone_type')} data{' - ' + prd.get('subService') if prd.get('subService') else ''}",
                          "price": str(pricing_spec.get('price')),
                          "currency": pricing_spec.get('currency_code'),
                          "unit": check_uom(pricing_spec.get('uom')),
                          "zone_name": zone.get('zone_name')
                      }
                      prices.append(price)

              elif (product.get('product_type', '').lower() == "sms" and base_charge and
                    json.loads(product.get('prd_characteristics', '{}')).get('service') in [
                        "AO", "AT", "MTAT", "AO Delivery Receipt Confirmation"
                    ]):
                  for pricing_spec in product.get('pricingSpecs', []):
                      prd = json.loads(product.get('prd_characteristics', '{}'))
                      if pricing_spec.get('price_type', '').lower() == "tiered":
                          price_val = ", ".join(
                              sorted(
                                  [
                                  f"{i['start_value']}-{i['end_value'] or ''} ["
                                  + ",".join(j['amount'] for j in i['chargedUnit'])
                                  + "]"
                                  for i in pricing_spec.get('ruleRange', [])
                                  ],

                                  key=lambda x: float(x.split('-')[0]) if x.split('-')[0] != '""' else float('inf')
                              )
                          )
                      else:
                          price_val = pricing_spec.get('price')

                      price = {
                          "serviceType": f"{zone.get('zone_type')} {product.get('product_type')} {prd.get('service')}{' - ' + prd.get('subService') if prd.get('subService') else ''}",
                          "price": str(price_val),
                          "currency": pricing_spec.get('currency_code'),
                          "unit": check_uom(pricing_spec.get('uom')),
                          "zone_name": zone.get('zone_name')
                      }
                      base_charge_list.append(price)

              else:
                  for pricing_spec in product.get('pricingSpecs', []):
                      prd = json.loads(product.get('prd_characteristics', '{}'))
                      price = {
                          "serviceType": f"{zone.get('zone_type')} {product.get('product_type')} {prd.get('service')}{' - ' + prd.get('subService') if prd.get('subService') else ''}",
                          "price": str(pricing_spec.get('price')),
                          "currency": pricing_spec.get('currency_code'),
                          "unit": check_uom(pricing_spec.get('uom')),
                          "zone_name": zone.get('zone_name')
                      }
                      prices.append(price)

    return base_charge_list if base_charge else prices
