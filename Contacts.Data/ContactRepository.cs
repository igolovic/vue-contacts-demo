using System.Data;
using Contacts.Models;
using Microsoft.Data.SqlClient;

namespace Contacts.Data
{
    public class ContactRepository : IContactRepository
    {
        private readonly string _connectionString;

        public ContactRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public int InsertContact(ContactDto contact)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_InsertContact", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@Name", contact.Name);
            cmd.Parameters.AddWithValue("@LastName", contact.LastName);
            cmd.Parameters.AddWithValue("@Email", (object?)contact.Email ?? DBNull.Value);

            conn.Open();
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        public ContactDto GetContactById(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_GetContactById", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();

            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                return new ContactDto
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    LastName = reader.GetString(2),
                    Email = reader.IsDBNull(3) ? null : reader.GetString(3),
                    Created = reader.GetDateTime(4),
                    Modified = reader.IsDBNull(5) ? null : reader.GetDateTime(5)
                };
            }

            return null;
        }

        public IEnumerable<ContactDto> GetAllContacts()
        {
            var contacts = new List<ContactDto>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_GetAllContacts", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            conn.Open();
            using var reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                contacts.Add(new ContactDto
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    LastName = reader.GetString(2),
                    Email = reader.IsDBNull(3) ? null : reader.GetString(3),
                    Created = reader.GetDateTime(4),
                    Modified = reader.IsDBNull(5) ? null : reader.GetDateTime(5)
                });
            }

            return contacts;
        }

        public void UpdateContact(ContactDto contact)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_UpdateContact", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@Id", contact.Id);
            cmd.Parameters.AddWithValue("@Name", contact.Name);
            cmd.Parameters.AddWithValue("@LastName", contact.LastName);
            cmd.Parameters.AddWithValue("@Email", (object?)contact.Email ?? DBNull.Value);

            conn.Open();
            cmd.ExecuteNonQuery();
        }

        public void DeleteContact(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_DeleteContact", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
        }

        public class PagedResult<T>
        {
            public List<T> Items { get; set; } = new();
            public int TotalCount { get; set; }
        }

        public async Task<PagedResult<ContactDto>> GetContactsPagedFilteredAsync(
            string? nameFilter, string? lastNameFilter, int pageIndex, int pageSize, string sortColumn = "LastName", string sortDirection = "ASC")
        {
            var result = new PagedResult<ContactDto>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_GetContactsFilteredPaged", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@NameFilter", (object?)nameFilter ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@LastNameFilter", (object?)lastNameFilter ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
            cmd.Parameters.AddWithValue("@PageSize", pageSize);
            cmd.Parameters.AddWithValue("@SortColumn", sortColumn);
            cmd.Parameters.AddWithValue("@SortDirection", sortDirection);

            await conn.OpenAsync();

            using var reader = await cmd.ExecuteReaderAsync();

            var contacts = new List<ContactDto>();
            while (await reader.ReadAsync())
            {
                contacts.Add(new ContactDto
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    LastName = reader.GetString(2),
                    Email = reader.IsDBNull(3) ? null : reader.GetString(3),
                    Created = reader.GetDateTime(4),
                    Modified = reader.IsDBNull(5) ? null : reader.GetDateTime(5)
                });
            }

            result.Items = contacts;

            // Move to next result set (TotalCount)
            if (await reader.NextResultAsync())
            {
                if (await reader.ReadAsync())
                {
                    result.TotalCount = reader.GetInt32(0);
                }
            }

            return result;
        }
    }
}