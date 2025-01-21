public without sharing class Patient {
	public Data data;
	public class Address {
		public String box_number;
		public String city;
		public String province;
		public String postcode;
	}
	public class Data {
		public String title;
		public String first_name;
		public String middle_name;
		public String last_name;
		public String date_of_birth;
		public String gender;
		public String nationality;
		public String preferred_language;
		public String thai_id_card_number;
		public String thai_id_card_copy;
		public String passport_number;
		public String passport_copy;
		public String primary_phone_number;
		public String email;
		public String country_of_residence;
		public Thailand_address thailand_address;
		public Address address;
	}

	public class Thailand_address {
		public String subdistrict;
		public String district;
		public String province;
		public String postcode;
	}

	
	public static Patient parse(String json) {
		return (Patient) System.JSON.deserialize(json, Patient.class);
	}
}