using Contacts.Data;
using Contacts.Models;
using Microsoft.AspNetCore.Mvc;
using static Contacts.Data.ContactRepository;

namespace Contacts.WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ContactsController : ControllerBase
    {
        private const int _pageSize = 3;
        private readonly IContactRepository _contactRepository;

        public ContactsController(IContactRepository contactRepository)
        {
            _contactRepository = contactRepository;
        }

        // POST: api/contacts
        [HttpPost]
        public ActionResult<int> Create([FromBody] ContactDto contact)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var newId = _contactRepository.InsertContact(contact);
            return CreatedAtAction(nameof(Create), new { id = newId }, newId);
        }

        // PUT: api/contacts/{id}
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] ContactDto contact)
        {
            _contactRepository.UpdateContact(contact);
            return NoContent();
        }

        // DELETE: api/contacts/{id}
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            _contactRepository.DeleteContact(id);
            return NoContent();
        }

        // GET: api/paged
        [HttpGet("paged")]
        public async Task<ActionResult<PagedResult<ContactDto>>> GetPaged(
            [FromQuery] string? nameFilter,
            [FromQuery] string? lastNameFilter,
            [FromQuery] int pageIndex = 0,
            [FromQuery] int pageSize = _pageSize,
            [FromQuery] string sortColumn = "LastName",
            [FromQuery] string sortDirection = "ASC")
        {
            if (pageIndex < 0) pageIndex = 0;
            if (pageSize <= 0) pageSize = _pageSize;

            var pagedContacts = await _contactRepository.GetContactsPagedFilteredAsync(
                nameFilter, lastNameFilter, pageIndex, pageSize, sortColumn, sortDirection);

            return Ok(pagedContacts);
        }
    }
}