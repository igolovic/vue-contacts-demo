using System.ComponentModel.DataAnnotations;

namespace Contacts.Models
{
    public class ContactDto
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Name is required.")]
        [MaxLength(100)]
        public string Name { get; set; }

        [Required(ErrorMessage = "Last name is required.")]
        [MaxLength(100)]
        public string LastName { get; set; }

        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        [MaxLength(254)]
        public string? Email { get; set; }

        public DateTime Created { get; set; }

        public DateTime? Modified { get; set; }
    }
}