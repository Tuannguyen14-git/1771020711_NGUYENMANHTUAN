using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.Models;

namespace Pcm.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CourtsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public CourtsController(PcmDbContext context)
    {
        _context = context;
    }

    // GET: api/courts
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var courts = await _context.Courts.ToListAsync();
        return Ok(courts);
    }

    // GET: api/courts/1
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound("Không tìm thấy sân");

        return Ok(court);
    }

    // POST: api/courts
    [HttpPost]
    public async Task<IActionResult> Create(_177_Courts model)
    {
        _context.Courts.Add(model);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = model.Id }, model);
    }

    // PUT: api/courts/1
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, _177_Courts model)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound("Không tìm thấy sân");

        court.Name = model.Name;
        court.IsActive = model.IsActive;
        court.PricePerHour = model.PricePerHour;
        court.Description = model.Description;

        await _context.SaveChangesAsync();
        return Ok(court);
    }

    // DELETE: api/courts/1
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound("Không tìm thấy sân");

        _context.Courts.Remove(court);
        await _context.SaveChangesAsync();

        return Ok("Đã xoá sân");
    }
}
