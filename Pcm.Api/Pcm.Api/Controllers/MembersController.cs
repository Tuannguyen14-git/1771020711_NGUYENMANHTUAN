using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.Models;

namespace Pcm.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MembersController : ControllerBase
{
    private readonly PcmDbContext _context;

    public MembersController(PcmDbContext context)
    {
        _context = context;
    }

    // GET: api/members
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var members = await _context.Members.ToListAsync();
        return Ok(members);
    }

    // GET: api/members/1
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var member = await _context.Members.FindAsync(id);
        if (member == null)
            return NotFound();

        return Ok(member);
    }

    // POST: api/members
    [HttpPost]
    public async Task<IActionResult> Create(_177_Members model)
    {
        _context.Members.Add(model);
        await _context.SaveChangesAsync();

        return Ok(model);
    }
}
