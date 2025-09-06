<img width="1272" height="355" alt="image" src="https://github.com/user-attachments/assets/25c7a4d6-1c5e-4223-83aa-ec462217c026" />
      
# Contacts App

**Contacts App** is a web application for managing contact information.   
The backend is built with .NET 9 (C# 13), providing a RESTful API for contact data management, including pagination and repository patterns.   
The frontend is developed using Vue.js, offering a responsive user interface for viewing, editing, and paginating contacts.   
   
## Features

- Create, read, update, and delete contacts
- Paginated contact listing
- RESTful API with .NET 9 Web API
- Modern Vue.js frontend

## Technologies

- .NET 9 (C# 13)
- ASP.NET Core Web API
- Vue.js

## Getting Started

1. **Database:**   
   - in SSQL Server Management Studio execute `create-test-database.sql`
   - set connection string in `/Contacts.WebApi/appsettings.json`  
1. **Backend:**  
   - Navigate to `/Contacts.WebApi`
   - Build and run the ASP.NET Core Web API

2. **Frontend:**  
   - Navigate to `/vue-contacts-app`
   - Install dependencies: `npm install`
   - Run the development server: `npm run serve`

