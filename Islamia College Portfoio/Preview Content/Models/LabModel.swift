import SwiftUI

struct Lab: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let isActive: Bool
    let hodName: String?
    let description: String
    
    var statusText: String {
        return isActive ? "Active" : "Inactive"
    }
    
    static let sampleLabs: [Lab] = [
            Lab(
                name: "Computer Lab",
                imageName: "IT Lab",
                isActive: true,
                hodName: "PROF. USMAN",
                description: """
                Lab Rules & Guidelines:
                
                • Students must maintain silence in the lab
                • No food or drinks allowed inside the lab
                • Handle all equipment with care
                • Report any technical issues immediately
                • Students are responsible for the assigned workstation
                • Internet usage is strictly for educational purposes
                • Save your work regularly to avoid data loss
                • Log out properly before leaving your workstation
                
                Available Software:
                • Microsoft Office Suite
                • Adobe Creative Suite
                • Programming IDEs (Visual Studio, Xcode, Android Studio)
                • Web Development Tools
                • Database Management Systems
                
                Operating Hours:
                Monday - Friday: 8:00 AM - 6:00 PM
                Saturday: 9:00 AM - 4:00 PM
                Sunday: Closed
                """
            ),
            Lab(
                name: "Physics Lab",
                imageName: "physcis LAb",
                isActive: true,
                hodName: "DR. AHMED ALI",
                description: """
                Lab Safety Rules:
                
                • Wear safety goggles and lab coats at all times
                • No unauthorized experiments
                • Handle chemicals and equipment carefully
                • Emergency exits must remain clear
                • Report accidents immediately
                • Wash hands before leaving the lab
                • Follow proper disposal procedures for chemicals
                
                Available Equipment:
                • Oscilloscopes and Function Generators
                • Digital Multimeters
                • Power Supplies
                • Microscopes
                • Spectrometers
                • Wave Motion Apparatus
                
                Lab Timing:
                Monday - Thursday: 9:00 AM - 5:00 PM
                Friday: 9:00 AM - 12:00 PM
                """
            ),
            Lab(
                name: "Chemistry Lab",
                imageName: "chemisty Lab",
                isActive: false,
                hodName: "PROF. SARA KHAN",
                description: """
                Safety Protocols:
                
                • Safety equipment is mandatory
                • No open flames near chemicals
                • Proper ventilation required
                • Emergency shower locations posted
                • First aid kit readily available
                • Proper waste disposal essential
                
                Available Resources:
                • Analytical Balance
                • pH Meters
                • Centrifuge
                • Heating Mantles
                • Distillation Apparatus
                • Fume Hoods
                
                Currently under maintenance.
                Expected reopening: Next semester.
                """
            ),
            Lab(
                name: "Biology Lab",
                imageName: "biology Lab",
                isActive: true,
                hodName: "DR. FATIMA SHAH",
                description: """
                Biosafety Guidelines:
                
                • Wear lab coats and safety gloves
                • No eating, drinking, or smoking in the lab
                • Wash hands thoroughly after handling specimens
                • Report any spills or accidents immediately
                • Proper disposal of biological waste
                • Keep work areas clean and organized
                • Use microscopes with care
                • Follow proper specimen handling procedures
                
                Laboratory Equipment:
                • Compound Microscopes
                • Stereomicroscopes
                • Autoclave
                • Incubators
                • Centrifuge
                • pH Meters
                • Spectrophotometer
                • Microtome
                
                Lab Schedule:
                Monday - Friday: 8:30 AM - 5:30 PM
                Saturday: 9:00 AM - 1:00 PM
                """
            ),
            Lab(
                name: "Mathematics Lab",
                imageName: "math Lab",
                isActive: true,
                hodName: "PROF. HASSAN MALIK",
                description: """
                Lab Guidelines:
                
                • Maintain quiet environment for calculations
                • Handle mathematical instruments carefully
                • Clean equipment after use
                • Report damaged instruments immediately
                • Work collaboratively and respectfully
                • Keep personal belongings organized
                • Follow proper calculator usage guidelines
                
                Available Resources:
                • Scientific Calculators
                • Graphing Calculators
                • Mathematical Software (MATLAB, Mathematica)
                • Geometric Instruments
                • Graph Papers and Charts
                • 3D Mathematical Models
                • Interactive Whiteboards
                • Statistical Analysis Tools
                
                Operating Hours:
                Monday - Friday: 9:00 AM - 5:00 PM
                Saturday: 10:00 AM - 3:00 PM
                """
            ),
            Lab(
                name: "Language Lab",
                imageName: "language Lab",
                isActive: true,
                hodName: "MS. AYESHA AHMED",
                description: """
                Language Learning Rules:
                
                • Maintain silence during listening exercises
                • Use headphones properly and carefully
                • No food or drinks near audio equipment
                • Report technical issues immediately
                • Participate actively in speaking exercises
                • Respect others' learning pace
                • Clean workstation after use
                
                Facilities Available:
                • Audio-Visual Equipment
                • Individual Listening Stations
                • Recording Devices
                • Interactive Language Software
                • Digital Dictionaries
                • Pronunciation Tools
                • Video Conferencing Setup
                • Multimedia Learning Materials
                
                Lab Timings:
                Monday - Thursday: 8:00 AM - 6:00 PM
                Friday: 8:00 AM - 4:00 PM
                Saturday: 9:00 AM - 2:00 PM
                """
            ),
            Lab(
                name: "Electronics Lab",
                imageName: "electronics Lab",
                isActive: true,
                hodName: "ENGR. MUHAMMAD KHAN",
                description: """
                Electronics Safety Rules:
                
                • Turn off power before making connections
                • Check circuit connections before powering on
                • Use proper tools for circuit assembly
                • Wear anti-static wrist straps when needed
                • Report equipment malfunctions immediately
                • Keep work area clean and organized
                • Handle ICs and components carefully
                • Follow proper soldering procedures
                
                Lab Equipment:
                • Digital Oscilloscopes
                • Function Generators
                • Power Supplies
                • Digital Multimeters
                • Breadboards and Proto Boards
                • Soldering Stations
                • Component Testers
                • Signal Analyzers
                
                Working Hours:
                Monday - Friday: 8:30 AM - 5:30 PM
                Saturday: 9:00 AM - 2:00 PM
                """
            ),
            Lab(
                name: "Geography Lab",
                imageName: "geography Lab",
                isActive: true,
                hodName: "DR. NADIA HUSSAIN",
                description: """
                Geography Lab Instructions:
                
                • Handle maps and globes with care
                • Use measuring instruments properly
                • Keep reference materials organized
                • Report damaged equipment immediately
                • Work quietly during research activities
                • Clean hands before handling maps
                • Return materials to proper locations
                
                Available Resources:
                • World Maps and Atlases
                • Topographic Maps
                • Globes (Physical and Political)
                • Compass and GPS Devices
                • Weather Instruments
                • Geological Samples
                • GIS Software
                • Surveying Equipment
                
                Lab Schedule:
                Monday - Friday: 9:00 AM - 5:00 PM
                Saturday: 10:00 AM - 3:00 PM
                """
            ),
            Lab(
                name: "Art & Design Lab",
                imageName: "art Lab",
                isActive: false,
                hodName: "PROF. ZAINAB ALI",
                description: """
                Studio Guidelines:
                
                • Wear appropriate clothing for art activities
                • Clean brushes and tools after use
                • Properly dispose of art materials
                • Handle artwork with clean hands
                • Keep workspace organized
                • Use ventilation when working with chemicals
                • Store personal artwork safely
                
                Studio Equipment:
                • Drawing Tables and Easels
                • Art Supplies (Paints, Brushes, Pencils)
                • Potter's Wheel
                • Kiln for Ceramics
                • Printing Press
                • Digital Art Tablets
                • Photography Equipment
                • Sculpture Tools
                
                Currently being renovated.
                Expected completion: End of this semester.
                """
            ),
            Lab(
                name: "Engineering Lab",
                imageName: "engineering Lab",
                isActive: true,
                hodName: "ENGR. TARIQ SHAH",
                description: """
                Engineering Safety Protocols:
                
                • Wear safety equipment at all times
                • Follow proper machine operation procedures
                • Report unsafe conditions immediately
                • Keep emergency exits clear
                • Use tools only for intended purposes
                • Maintain clean and organized workspace
                • Follow lockout/tagout procedures
                • Get supervisor approval for new experiments
                
                Laboratory Facilities:
                • CAD Workstations
                • 3D Printers
                • CNC Machines
                • Testing Equipment
                • Measurement Tools
                • Material Testing Machines
                • Simulation Software
                • Workshop Tools
                
                Operating Schedule:
                Monday - Friday: 8:00 AM - 6:00 PM
                Saturday: 9:00 AM - 4:00 PM
                """
            )
        ]
}
