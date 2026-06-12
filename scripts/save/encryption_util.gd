extends Node

class_name EncryptionUtil

const ENCRYPTION_KEY = "EclipseFrontier2024SecretKey1234"

static func encrypt_data(plain_text: String) -> String:
	if not Constants.SAVE_ENCRYPTION_ENABLED:
		return plain_text
	
	var cipher = AESContext.new()
	var key = _generate_key(ENCRYPTION_KEY)
	
	if cipher.start(AESContext.MODE_ECB_ENCRYPT, key) != OK:
		return plain_text
	
	var encrypted = cipher.update(plain_text.to_utf8_buffer())
	cipher.finish()
	
	return encrypted.hex_encode()

static func decrypt_data(encrypted_text: String) -> String:
	if not Constants.SAVE_ENCRYPTION_ENABLED:
		return encrypted_text
	
	var cipher = AESContext.new()
	var key = _generate_key(ENCRYPTION_KEY)
	
	if cipher.start(AESContext.MODE_ECB_DECRYPT, key) != OK:
		return encrypted_text
	
	var encrypted_bytes = encrypted_text.hex_decode()
	var decrypted = cipher.update(encrypted_bytes)
	cipher.finish()
	
	return decrypted.get_string_from_utf8()

static func _generate_key(password: String) -> PackedByteArray:
	var hash = HashingContext.new()
	hash.start(HashingContext.HASH_SHA256)
	hash.update(password.to_utf8_buffer())
	return hash.finish()