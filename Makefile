CHART_NAME := veecode-devportal-chart
CHART_DIR := $(CHART_NAME)
CHART_PACKAGE := $(CHART_NAME)-*.tgz
CHARTS_DIR := charts

.PHONY: all deps package index publish clean release

all: publish

release:
	./update_version.sh
	@echo "RELEASE"
	$(MAKE) publish

deps:
	cd $(CHART_DIR) && helm dependency update

package: deps
	helm package $(CHART_DIR) --destination $(CHARTS_DIR)

index: package
	helm repo index $(CHARTS_DIR) --url https://veecode-platform.github.io/next-charts/charts

publish: index
	@git checkout gh-pages
	@cp $(CHARTS_DIR)/* .
	@git add *.tgz index.yaml
	@git commit -m "Publish new chart version"
	@git push origin gh-pages
	@git checkout -

clean:
	rm -f $(CHARTS_DIR)/*.tgz
	rm -f $(CHARTS_DIR)/index.yaml
