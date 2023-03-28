# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# hospital = Hospital.create(name: 'MediCare' , address: 'Coimbatore West ' , mail: 'medicare@gmail.com')
# Doctor.create(name:'Bharath' , hospital: hospital , age: 20 , email: 'bharath@medicare.com' , address: 'karur' , dateofjoining:DateTime.now ,specialization:'cardiology' )
# Doctor.create(
#   [{
#      name:'Gowthaman' , hospital: hospital , age: 21 , email: 'gowthaman@medicare.com' , address: 'Nammakal' , dateofjoining:DateTime.now ,specialization:'Dentist'
#    },
#
#   {
#     name:'Sri Ram' , hospital: hospital , age: 20 , email: 'srira@medicare.com' , address: 'Theni' , dateofjoining:DateTime.now ,specialization:'ENT'
#   },
#    {
#      name:'Ragav' , hospital: hospital , age: 20 , email: 'Ragav@medicare.com' , address: 'karur' , dateofjoining:DateTime.now ,specialization:'Dentist'
#    }]
# )
# Doctor.create(name:'Bharath' , hospital:  , age: 20 , email: 'bharath@medicare.com' , address: 'karur' , dateofjoining:DateTime.now ,specialization:'cardiology' )

# Patient.create name:'krishna' , sex:'male' , email:'krishna@gmail.com' , mobile_number:'6383703693' , age:20 , address:'tirunelveli'


# Hospital.create([{
#                    name: 'Appolo Hospitals' , address: 'Coimbatore North ' , mail: 'Appollo@gmail.com'
#                  } ,
#                  {
#                    name:'Kauveri Hospital' , address: 'Coimbatore West ' , mail: 'kauveri@gmail.com'
#                  }])

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?