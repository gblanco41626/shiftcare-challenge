
# Shiftcare Challenge CLI App

A simple Ruby command-line application that can:

- Fetch JSON data from a URL or a local file  
- Search records by name  
- Find duplicate email entries

This project demonstrates a clean CLI architecture with separated concerns: commands, services, and utilities.
## Setup Instructions

**Clone the repository:**

```bash
git clone <repository-url>
cd shiftcare-challenge
```

**Install dependencies:**
```bash
bundle install
```

**Make the CLI executable (if needed):**
```bash
chmod +x bin/shiftcare_challenge
```

**Run tests:**
```bash
bundle exec rspec
```
## Usage

```bash
./bin/shiftcare_challenge search --file <url | local file> --query <search query>

./bin/shiftcare_challenge find-duplicate --file <url | local file>

./bin/shiftcare_challenge --help
```


## Assumptions & Limitations

This CLI tool is designed to be simple and functional but makes a few assumptions that impact how it handles certain inputs and validations:

- **Client data structure**
  - The input JSON is expected to be an array of hashes, where each hash represents a client record.
  - Each client hash must contain a full_name key used for searching and email used for duplicate detection.
  - Missing or malformed data (e.g., missing full_name, non-hash entries) may lead to unexpected behavior or skipped results.
- **URL validation**
  - URLs beginning with https or http are considered valid, even if malformed.
  - The following examples will incorrectly pass validation:
  - Missing protocol separator: https:example.com
    - Invalid domain name: https://example
    - Invalid characters in path: http://www.example.com/page with spaces.html
- **Error handling**
  - Invalid URLs or file paths will return an empty array during processing rather than raise an error.
- **Command validation**
  - Valid commands are registered on load

## Notes for Future Improvements

- **Improve URL and file path validation**
  - Add stricter validation and sanitization to prevent injection risks and invalid data.
- **Dependency injection for JSON parsing**
  - Allow pluggable JSON parsing services for better testing and maintainability.
  - Makes it easier to replace or mock the parser without modifying command logic.
- **Command-specific help**
  - Extend the OptionParser to provide dedicated help messages for each command (e.g. search -h).

## Improvements made after Initial implementation

- **Introduce a Command Registry**
  - Replace dynamic subclass scanning with a centralized registry that explicitly registers each command.
  - Benefits:
    - Improved performance for larger codebases.
    - Easier debugging and clearer error handling.
    - More flexible for adding command metadata (aliases, descriptions, usage examples).
- **Improve required options for each command**
  - Define and dynamically validate required options per command (e.g., --file, --query).
  - This makes it easier to catch missing parameters early, improves test coverage, and keeps command behavior consistent.
  - Dynamically validating required options enhances testability and reduces the risk of runtime errors.
