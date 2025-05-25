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

        // GET: api/contacts
        [HttpGet]
        public ActionResult<IEnumerable<ContactDto>> GetAll()
        {
            var contacts = _contactRepository.GetAllContacts();
            return Ok(contacts);
        }

        // GET: api/contacts/{id}
        [HttpGet("{id}")]
        public ActionResult<ContactDto> GetById(int id)
        {
            var contact = _contactRepository.GetContactById(id);
            if (contact == null)
                return NotFound();

            return Ok(contact);
        }

        // POST: api/contacts
        [HttpPost]
        public ActionResult<int> Create([FromBody] ContactDto contact)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var newId = _contactRepository.InsertContact(contact);
            return CreatedAtAction(nameof(GetById), new { id = newId }, newId);
        }

        // PUT: api/contacts/{id}
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] ContactDto contact)
        {
            if (id != contact.Id)
                return BadRequest("Contact ID mismatch.");

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