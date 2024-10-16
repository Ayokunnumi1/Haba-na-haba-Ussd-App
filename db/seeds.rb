# Find or create districts and counties as before

# Kampala Metropolitan Region
wakiso = District.find_or_create_by!(name: 'Wakiso District')
mukono = District.find_or_create_by!(name: 'Mukono District')

# Busoga Region
jinja = District.find_or_create_by!(name: 'Jinja District')
iganga = District.find_or_create_by!(name: 'Iganga District')

# Teso Region
soroti = District.find_or_create_by!(name: 'Soroti District')
katakwi = District.find_or_create_by!(name: 'Katakwi District')

# Bugisu Region
mbale = District.find_or_create_by!(name: 'Mbale District')
bududa = District.find_or_create_by!(name: 'Bududa District')

# Mid-West Region
kakumiro = District.find_or_create_by!(name: 'Kakumiro District')
kyankwanzi = District.find_or_create_by!(name: 'Kyankwanzi District')

# Find or create counties as before

# Wakiso District
busiro = County.find_or_create_by!(name: 'Busiro', district: wakiso)

# Mukono District
mukono_county = County.find_or_create_by!(name: 'Mukono County', district: mukono)

# Jinja District
butembe = County.find_or_create_by!(name: 'Butembe', district: jinja)

# Iganga District
kigulu = County.find_or_create_by!(name: 'Kigulu', district: iganga)

# Soroti District
soroti_county = County.find_or_create_by!(name: 'Soroti County', district: soroti)

# Katakwi District
usuk = County.find_or_create_by!(name: 'Usuk', district: katakwi)

# Mbale District
bungokho = County.find_or_create_by!(name: 'Bungokho', district: mbale)

# Bududa District
manjiya = County.find_or_create_by!(name: 'Manjiya', district: bududa)

# Kakumiro District
bugangaizi = County.find_or_create_by!(name: 'Bugangaizi', district: kakumiro)

# Kyankwanzi District
kiboga = County.find_or_create_by!(name: 'Kiboga', district: kyankwanzi)

# Add branches with phone numbers

Branch.find_or_create_by!(name: 'Busiro Branch', phone_number: '256700111111', district: wakiso, county: busiro)
Branch.find_or_create_by!(name: 'Mukono County Branch', phone_number: '256700222222', district: mukono, county: mukono_county)
Branch.find_or_create_by!(name: 'Butembe Branch', phone_number: '256700333333', district: jinja, county: butembe)
Branch.find_or_create_by!(name: 'Kigulu Branch', phone_number: '256700444444', district: iganga, county: kigulu)
Branch.find_or_create_by!(name: 'Soroti County Branch', phone_number: '256700555555', district: soroti, county: soroti_county)
Branch.find_or_create_by!(name: 'Usuk Branch', phone_number: '256700666666', district: katakwi, county: usuk)
Branch.find_or_create_by!(name: 'Bungokho Branch', phone_number: '256700777777', district: mbale, county: bungokho)
Branch.find_or_create_by!(name: 'Manjiya Branch', phone_number: '256700888888', district: bududa, county: manjiya)
Branch.find_or_create_by!(name: 'Bugangaizi Branch', phone_number: '256700999999', district: kakumiro, county: bugangaizi)
Branch.find_or_create_by!(name: 'Kiboga Branch', phone_number: '256701000000', district: kyankwanzi, county: kiboga)

puts "Districts, counties, and branches successfully created!"
