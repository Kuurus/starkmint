import { ConnectedStarknetWindowObject } from 'get-starknet-core';

export type TAddress = ConnectedStarknetWindowObject | string | undefined;

// inspired by Hop Protocol https://github.com/hop-protocol/hop
class Address {
	public readonly address: string;

	constructor(address: TAddress) {
		let newAddress;
		if (address instanceof Address) {
			newAddress = address.toString();
		} else if (typeof address === 'string') {
			newAddress = address;
		}

		const isAddress = /^0x[a-fA-F0-9]{40}$/.test(newAddress || '');

		if (!newAddress || isAddress) {
			throw new Error('Invalid address');
		}

		this.address = newAddress;
	}

	static from(address: TAddress): Address {
		return new Address(address);
	}

	toString(): string {
		return this.address;
	}

	truncate(): string {
		return this.address.slice(0, 6) + '...' + this.address.slice(38, 42);
	}

	toLowercase(): string {
		return this.address.toLowerCase();
	}
}

export default Address;
