# Quick Start Guide - Sorting Center Operations

## First Time Setup (5 Minutes)

### 1. Create Boxes (Box Management)
```
Click: Kiosk Integration → Box Management → Create Box

Box A1 → Mirpur Kiosk (100 parcels max)
Box A2 → Dhanmondi Kiosk (100 parcels max)
Box B1 → Gulshan Kiosk (100 parcels max)
Box B2 → Uttara Kiosk (100 parcels max)
```

### 2. Add Riders (If needed for returns)
```
Click: Riders → Create Rider
Fill: Name, Phone, Vehicle Type
Save
```

---

## Daily Operations (Simple Flow)

### MORNING: Check Incoming

**Pre-Data Dashboard**
```
What: See parcels coming today (before they arrive)
Look for: Tracking numbers, customer names, COD amounts
Action: Just review - no action needed yet
```

---

### MAIN WORK: Sort Parcels

**Scanning Interface** ⭐ MOST IMPORTANT SCREEN

```
1. SCAN QR code (or enter tracking number)
   ↓
2. AI SHOWS recommended kiosk
   - Green (80-100%) = Trust it
   - Yellow (60-79%) = Review it
   - Orange (<60%) = Double check
   ↓
3. SELECT BOX for that kiosk
   - Pick box assigned to recommended kiosk
   - Green boxes = Available
   - Red boxes = Full (pick different box)
   ↓
4. CLICK "Assign to Box"
   ↓
5. NEXT parcel (repeat)
```

**Example**:
```
Scan: TRK-123456
↓
AI: "Mirpur Kiosk (95% confidence)"
↓
Pick: Box A1 (Mirpur)
↓
Assign → Done!
```

---

### AFTERNOON: Send to Kiosk

**Dispatch Preparation**

```
When: Boxes are 80-100% full

1. Click: Dispatch Preparation
2. See: Parcels grouped by kiosk
3. Click: "Send to Kiosk" button
4. Review: List of parcels
5. Confirm: "Confirm & Send"
6. Done: Kiosk receives data via API
7. Physical: Load box on truck, send to kiosk
```

---

### AS NEEDED: Handle Returns

**Return Parcels**

```
When: Kiosk sends return request

1. View: New returns (yellow badge)
2. Click: "Assign Rider"
3. Select: Available rider
4. Save: Rider goes to kiosk to pickup
5. Update: Mark as Collected → Received → Processed
```

---

## Screen Cheat Sheet

| Screen | When to Use | Main Action |
|--------|-------------|-------------|
| **Dashboard** | Start of day | Check metrics |
| **Pre-Data** | Morning | Review incoming |
| **Scanning** ⭐ | All day | Scan & sort parcels |
| **Box Mgmt** | Setup + monitoring | Create boxes, check capacity |
| **Dispatch** | When boxes full | Send to kiosks |
| **Returns** | As returns come | Assign riders |
| **COD** | End of day | Track cash |
| **Parcels** | Lookup specific | Search tracking# |
| **Riders** | Team management | Add/edit riders |

---

## Color Codes

### Box Status:
- 🟢 **Green** = Available (<70% full)
- 🟡 **Yellow** = In Use (70-90% full)
- 🔴 **Red** = Full (90-100% full)
- 🔵 **Blue** = Dispatched

### AI Confidence:
- 🟢 **Green** = 80-100% (trust it!)
- 🟡 **Yellow** = 60-79% (probably OK)
- 🟠 **Orange** = <60% (check manually)

### Parcel Status:
- 🟡 **Pre-Data Received** = Info received, parcel coming
- 🟢 **Physical Received** = Parcel arrived at center
- 🔵 **Sorted** = Assigned to box
- 🟣 **Dispatched** = Sent to kiosk

---

## Common Questions

**Q: Why do I see parcels in Pre-Data but they're not here yet?**
A: Pre-data comes BEFORE physical parcels. It's advance notice from kiosk system.

**Q: Which box should I use?**
A: Use boxes assigned to the kiosk AI recommends. Check Box Management to see which box goes to which kiosk.

**Q: What if AI confidence is orange (<60%)?**
A: Manually check customer address. Maybe customer is between two kiosks. Use your judgment.

**Q: When do I dispatch?**
A: When box is 80-100% full OR at end of day (even if not full).

**Q: Do I deliver to customers?**
A: NO! You only sort and send to KIOSK. Kiosk delivers to customer.

**Q: What is return_center_id in QR code?**
A: If customer refuses delivery at kiosk, kiosk knows which sorting center to return to. Usually your center.

---

## Keyboard Shortcuts (Coming Soon)

- `Ctrl+S` = Quick scan
- `Ctrl+D` = Dashboard
- `Ctrl+B` = Box management
- `Esc` = Close modal

---

## Success Metrics

Track these daily:
- ✅ **Scanning Rate**: Parcels sorted per hour (target: 50+)
- ✅ **Box Utilization**: % of boxes filled (target: 80%+)
- ✅ **Dispatch Rate**: Boxes sent per day (target: all full boxes)
- ✅ **Return Rate**: % of parcels returned (target: <5%)
- ✅ **AI Accuracy**: % of green confidence scores (target: 90%+)

---

## Emergency Contacts

- **Technical Support**: [Add contact]
- **Kiosk System Support**: [Add contact]
- **Super Admin**: [Add contact]

---

**You're ready to start! Go to Scanning Interface and scan your first parcel! 🚀**
