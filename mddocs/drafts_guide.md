# Draft Configuration

Drafts are enabled by default, asks the user to save a draft before leave any VideoEditor screen.

## Usage

Specify instance of ```DraftsConfig``` in ```FeaturesConfig``` builder to change drafts configuration:

```dart
final config = FeaturesConfigBuilder()
      .setDraftConfig(DraftsConfig.fromOption(DraftsOption.auto))
      ...
      .build();
```

### Options

- ```DraftsOption.askToSave``` - drafts enabled, asks the user to save a draft
- ```DraftsOption.auto``` - drafts enabled, saved by default without asking the user
- ```DraftsOption.closeOnSave``` - drafts enabled, asks the user to save a draft without export
- ```DraftsOption.disable``` - disabled drafts