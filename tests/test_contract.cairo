use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait};
use traits::TryInto;
use option::OptionTrait;
use starknet_forge_template::IHelloStarknetSafeDispatcher;
use starknet_forge_template::IHelloStarknetSafeDispatcherTrait;
use starknet_forge_template::HelloStarknet;

fn deploy_contract(name: felt252) -> ContractAddress {
    //Create call data for the constructor
    let reciepient = starknet::contract_address_const::<0x01>();
    let supply : felt252 = 20000000;
    let mut calldata = array![];
    let contract = declare(name);
    //deploy the contract
    contract.deploy(@calldata).unwrap()
}

#[test]
fn test_increase_balance() {
    


    let contract_address = deploy_contract('HelloStarknet');

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();
    assert(balance_before == 0, 'Invalid balance');

    safe_dispatcher.increase_balance(42).unwrap();

    let balance_after = safe_dispatcher.get_balance().unwrap();
    assert(balance_after == 42, 'Invalid balance');
}

#[test]
fn test_cannot_increase_balance_with_zero_value() {
    let contract_address = deploy_contract('HelloStarknet');

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();
    //factory
    let reciepient = starknet::contract_address_const::<0x01>();
    let supply : felt252 = 20000000;
    let address = safe_dispatcher.deploy_contract(HelloStarknet::TEST_CLASS_HASH);
    //read address
    //println!("address: {}", address);
    //assert(address != address,'toto');
    assert(balance_before == 0, 'Invalid balance');

    match safe_dispatcher.increase_balance(0) {
        Result::Ok(_) => panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
        }
    };
}