# Draft Configuration

Drafts are enabled by default, asks the user to save a draft before leave any VideoEditor screen.

## Usage

Specify instance of ```DraftConfig``` in ```FeaturesConfig``` builder to change drafts configuration:

```dart
final config = FeaturesConfigBuilder()
      .setDraftConfig(DraftConfig.fromOption(DraftOption.auto))
      ...
      .build();
```

### Configurations

- Ask to save - drafts enabled, asks the user to save a draft
- Save by default - drafts enabled, saved by default without asking the user
- Close on save - drafts enabled, asks the user to save a draft without export
- Disable - disabled drafts