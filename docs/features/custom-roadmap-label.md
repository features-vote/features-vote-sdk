# Custom roadmap title

`Customization` now decodes two optional fields from the public project
payload: `roadmapLabel` and `changelogLabel`.

`RoadmapView` uses `roadmapLabel` as its navigation title, falling back to
`"Roadmap"`. `ChangelogView` does not load the project, so its title is
unchanged.

Set the label in the Features.Vote admin under **Settings → Customization →
Roadmap tab label**.
