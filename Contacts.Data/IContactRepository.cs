using Contacts.Models;
using static Contacts.Data.ContactRepository;

namespace Contacts.Data
{
    public interface IContactRepository
    {
        void DeleteContact(int id);
        int InsertContact(ContactDto contact);
        void UpdateContact(ContactDto contact);
        Task<PagedResult<ContactDto>> GetContactsPagedFilteredAsync(string? nameFilter, string? lastNameFilter, int pageIndex, int pageSize, string sortColumn, string sortDirection);
    }
}