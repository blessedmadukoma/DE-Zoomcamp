if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    # Remove rows where passenger count or trip distance is zero
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]
    
    # Create new column lpep_pickup_date
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    
    # Rename columns to snake case
    data = data.rename(columns=lambda x: x.lower())
    data = data.rename(columns={'vendorid': 'vendor_id'})  # Example of renaming specific columns
    
    return data

@test
def test_output(output, *args) -> None:
    """
    Assertion
    """
    assert output['vendor_id'].isin([1, 2]).all(), "Vendor ID should be 1 or 2"
    assert (output['passenger_count'] > 0).all(), "Passenger count should be greater than 0"
    assert (output['trip_distance'] > 0).all(), "Trip distance should be greater than 0"

