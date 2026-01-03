# Vale styles for writing software requirements

Vale styles for writing software requirements.

## Styles Included

TBD

## Installation

### Via Vale packages

Add to your `.vale.ini`:

```ini
StylesPath = .vale
MinAlertLevel = warning

Packages = https://github.com/jsonlt/vale-jsonlt/releases/latest/download/RequirementsWriting.zip

[*.md]
BasedOnStyles = Vale, RequirementsWriting
```

Then run:

```bash
vale sync
```

## License

[Creative Commons Attribution 4.0 International License](LICENSE).
