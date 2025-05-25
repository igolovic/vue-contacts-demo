using System.ComponentModel.DataAnnotations;

namespace Contacts.Models
{
    public class ContactDto
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; }

        [Required]
        [MaxLength(100)]
        public string LastName { get; set; }

        [Required]
        [EmailAddress]
        [MaxLength(254)]
        public string Email { get; set; }

        public DateTime Created { get; set; }

        public DateTime? Modified { get; set; }
    }
}